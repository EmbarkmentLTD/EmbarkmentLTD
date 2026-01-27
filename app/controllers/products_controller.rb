class ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy, :toggle_availability ]
  before_action :authenticate_user!, except: [ :index, :show, :search ]
  before_action :authorize_supplier, only: [ :new, :create ]  # Only for creating new products
  before_action :authorize_product_management, only: [ :edit, :update, :destroy, :toggle_availability ]

  def index
    @products = Product.all.includes(:user, :reviews)

    # Apply filters
    @products = @products.by_category(params[:categories]) if params[:categories].present?
    @products = @products.organic if params[:organic] == "true"
    @products = @products.in_stock if params[:in_stock] == "true"
    @products = @products.where("price >= ?", params[:min_price]) if params[:min_price].present?
    @products = @products.where("price <= ?", params[:max_price]) if params[:max_price].present?
    @products = @products.where("location ILIKE ?", "%#{params[:location]}%") if params[:location].present?
    @products = @products.where("average_rating >= ?", params[:min_rating]) if params[:min_rating].present?
    @products = @products.search(params[:search]) if params[:search].present?

    # Apply sorting
    @products = apply_sorting(@products)

    @products = @products.page(params[:page]).per(12)

    setup_categories
    setup_price_range
  end

  def show
    @product = Product.find(params[:id])
    @reviews = @product.reviews.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
    @related_products = Product.where(category: @product.category)
                              .where.not(id: @product.id)
                              .in_stock
                              .limit(4)
    # Initialize new review safely
    @review = Review.new

    # Set instance variable for review permission check
    @can_review = user_signed_in? && current_user.buyer? && current_user != @product.user && !@product.reviews.exists?(user_id: current_user.id)
  end

  def new
    @product = Product.new
  end

  def create
    @product = current_user.products.new(product_params)

    if @product.save

      redirect_to @product, notice: "Product was successfully created."
    else
      flash.now[:alert] = "Failed to create product. Please check the form for errors."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)


      redirect_to @product, notice: "Product was successfully updated."
    else
      flash.now[:alert] = "Failed to update product. Please check the form for errors."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: "Product was successfully deleted."
  end

  def toggle_availability
    if @product.update(stock_quantity: @product.in_stock? ? 0 : 100)
      status = @product.in_stock? ? "back in stock" : "out of stock"
      redirect_to my_products_products_path, notice: "Product marked as #{status}."
    else
      redirect_to my_products_products_path, alert: "Failed to update product availability."
    end
  end

  def my_products
    if current_user.admin?
      @products = Product.all.includes(:reviews).order(created_at: :desc).page(params[:page]).per(12)
    else
      @products = current_user.products.includes(:reviews).order(created_at: :desc).page(params[:page]).per(12)
    end
    render :my_products  # Changed to render dedicated my_products view
  end

  def search
    @products = Product.search(params[:query])
                      .includes(:user, :reviews)
                      .page(params[:page])
                      .per(12)
    setup_categories
    setup_price_range
    render :index
  end

  def quotation
    @product = Product.find(params[:id])
    @quantity = params[:quantity] || 1

    # Add to quotation session
    session[:quotation] ||= {}
    session[:quotation][@product.id.to_s] = @quantity.to_i

    render :quotation
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def authorize_supplier
    unless current_user.can_supply?
      redirect_to products_path, alert: "Only suppliers can list products. Please contact support to upgrade your account."
    end
  end

  def authorize_product_management
    unless current_user.can_manage_product?(@product)
      redirect_to products_path, alert: "Not authorized to manage this product."
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :category, :price,
                                   :stock_quantity, :unit, :location,
                                   :is_organic, :featured, :harvest_date,
                                   :expiry_date, images: [])  # Added images
  end

  def apply_sorting(products)
    case params[:sort_by]
    when "price_low"
      products.order(price: :asc)
    when "price_high"
      products.order(price: :desc)
    when "rating"
      products.order(average_rating: :desc)
    when "newest"
      products.order(created_at: :desc)
    when "name"
      products.order(name: :asc)
    else
      products.order(created_at: :desc)
    end
  end

  def setup_categories
    @categories = Product::CATEGORIES.map do |key, name|
      {
        key: key,
        name: name,
        icon: Product.new(category: key).category_icon,
        count: Product.where(category: key).count
      }
    end
  end

  def setup_price_range
    @min_price = Product.minimum(:price) || 0
    @max_price = Product.maximum(:price) || 100
  end
end
