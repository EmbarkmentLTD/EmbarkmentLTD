class ReviewsController < ApplicationController
  before_action :set_product
  before_action :require_admin
  before_action :authenticate_user!
  before_action :set_review, only: [:destroy]

  def create
    @review = @product.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: 'Review was successfully created.'
    else
      redirect_to @product, alert: 'Failed to create review.'
    end
  end

    def index
      @reviews = Review.includes(:user, :product)
                      .order(created_at: :desc)
                      .page(params[:page])
                      .per(20)
    end

    def show
    end

  def destroy
    if @review.user == current_user
      @review.destroy
      redirect_to @product, notice: 'Review was successfully deleted.'
    else
      redirect_to @product, alert: 'Not authorized.'
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end