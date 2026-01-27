class Admin::ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_support
  before_action :set_review, only: [ :show, :edit, :update, :destroy ]

  def index
    @reviews = Review.includes(:user, :product)
                     .order(created_at: :desc)
                     .page(params[:page])
                     .per(20)
  end

  def show
  end

  def edit
  end

  def update
    if @review.update(review_params_for_role)
      redirect_to admin_review_path(@review), notice: "Review was successfully updated."
    else
      flash.now[:alert] = @review.errors.full_messages.to_sentence.presence || "Failed to update review."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless current_user.admin?
      redirect_to admin_review_path(@review), alert: "Not authorized."
      return
    end

    @review.destroy
    redirect_to admin_reviews_path, notice: "Review was successfully deleted."
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def require_admin_or_support
    unless current_user.admin? || current_user.support?
      redirect_to root_path, alert: "Not authorized."
    end
  end

  def review_params_for_role
    if current_user.admin?
      params.require(:review).permit(:rating, :comment, :flagged)
    else
      params.require(:review).permit(:comment, :flagged)
    end
  end
end
