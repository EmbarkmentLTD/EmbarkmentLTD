class ReviewsController < ApplicationController
  before_action :set_product
  before_action :authenticate_user!
  before_action :set_review, only: [ :destroy, :update ]
  before_action :ensure_buyer_can_review, only: [ :create ]
  before_action :ensure_can_update_review, only: [ :update ]

  def create
    @review = @product.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: "Review was successfully created."
    else
      redirect_to @product, alert: @review.errors.full_messages.to_sentence.presence || "Failed to create review."
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

  def update
    if supplier_response_update?
      if @review.update(supplier_response_params.merge(supplier_response_at: Time.current))
        redirect_to @product, notice: "Response was successfully posted."
      else
        redirect_to @product, alert: @review.errors.full_messages.to_sentence.presence || "Failed to post response."
      end
    else
      if @review.update(admin_support_review_params)
        redirect_to admin_review_path(@review), notice: "Review was successfully updated."
      else
        redirect_to edit_admin_review_path(@review), alert: @review.errors.full_messages.to_sentence.presence || "Failed to update review."
      end
    end
  end

  def destroy
    if @review.user == current_user || current_user.admin?
      @review.destroy
      redirect_to @product, notice: "Review was successfully deleted."
    else
      redirect_to @product, alert: "Not authorized."
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

  def supplier_response_params
    params.require(:review).permit(:supplier_response)
  end

  def admin_support_review_params
    if current_user.admin?
      params.require(:review).permit(:rating, :comment, :flagged)
    else
      params.require(:review).permit(:comment, :flagged)
    end
  end

  def ensure_buyer_can_review
    unless current_user.buyer? && current_user != @product.user
      redirect_to @product, alert: "Only buyers can review this product."
      return
    end

    if @product.reviews.exists?(user_id: current_user.id)
      redirect_to @product, alert: "You have already reviewed this product."
    end
  end

  def ensure_can_update_review
    return if supplier_response_update? && can_respond_to_review?
    return if admin_support_update?

    redirect_to @product, alert: "Not authorized."
  end

  def supplier_response_update?
    params[:review]&.key?(:supplier_response)
  end

  def can_respond_to_review?
    return false unless current_user
    current_user.can_manage_product?(@product)
  end

  def admin_support_update?
    current_user&.admin? || current_user&.support?
  end
end
