class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.all.includes(:user).order(created_at: :desc).page(params[:page]).per(20)
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Product deleted successfully."
  end

  def new
  @product = Product.new
 end

 def create
  @product = Product.new(product_params)
  if @product.save
    redirect_to admin_products_path, notice: "Product created successfully."
  else
    render :new, status: :unprocessable_entity
  end
 end

 def edit
 end

 def update
  if @product.update(product_params)
    redirect_to admin_products_path, notice: "Product updated successfully."
  else
    render :edit, status: :unprocessable_entity
  end
 end

 def show
   # Show action for individual product details in admin
 end


  private

  def set_product
    @product = Product.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: "Not authorized." unless current_user.admin?
  end

  def product_params
permitted_params = [ :name, :description, :price, :category, :location, :unit, :stock_quantity, :harvest_date, :expiry_date, :is_organic, :featured, images: [] ]
  permitted_params << :user_id if current_user.admin?

  params.require(:product).permit(permitted_params)
  end
end
