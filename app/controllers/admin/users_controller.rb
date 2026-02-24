class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_user, only: [ :edit, :update, :destroy, :show ]

  def index
    @users = User.left_joins(:products)
                 .select("users.*, MAX(products.created_at) AS last_product_created_at")
                 .group("users.id")
                 .order("users.created_at DESC")
                 .page(params[:page]).per(20)
  end

  def edit
    unless @user
        redirect_to admin_users_path, alert: "User not found."
        nil
    end
  end

  def update
      # If password is blank, remove it from params so we don't update it
      update_params = user_params
      if update_params[:password].blank?
        update_params.delete(:password)
        update_params.delete(:password_confirmation)
      end

      if @user.update(update_params)
        # Handle avatar removal
        if params[:user][:remove_avatar] == "1"
          @user.avatar.purge
        end

        redirect_to admin_user_path(@user), notice: "User updated successfully."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
  end

  def new
  @user = User.new
  end

  def create
  @user = User.new(user_params)
      # Set a default password if none provided and it's a new user
      if @user.password.blank?
        @user.password = Devise.friendly_token.first(12) # Generate random password
      end

      if @user.save
        redirect_to admin_user_path(@user), notice: "User created successfully."
      else
        flash.now[:alert] = @user.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
  end

  def show
    # @user is set by set_user
  end

  def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "User deleted successfully."
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: "Not authorized." unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :location, :role, :admin, :avatar, :password, :password_confirmation, :remove_avatar)
  end
end
