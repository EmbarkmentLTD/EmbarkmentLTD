class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user, only: [ :edit, :update ]

  def show
    @products = @user.products.includes(:reviews).order(created_at: :desc).page(params[:page]).per(12)
    @reviews = @user.reviews.includes(:product).order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def profile
    @user = current_user
    @quotation_requests = current_user.quotation_requests.includes(:quotation_items, :user).order(created_at: :desc).page(params[:page]).per(10)
    @products = current_user.products.includes(:reviews).order(created_at: :desc).page(params[:page]).per(10)
  end

  def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "User deleted successfully."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    redirect_to root_path, alert: "Not authorized." unless @user == current_user || current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :location, :avatar, :role)
  end
end
