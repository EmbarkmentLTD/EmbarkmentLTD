class ApplicationController < ActionController::Base
   include VerificationRequired
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :location, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :location, :avatar, :role])
  end

  def after_sign_in_path_for(resource)
    products_path
  end

  def logged_in?
    user_signed_in?
  end
  helper_method :logged_in?

  def current_user
    super
  end
  helper_method :current_user

  # Helper method to check if user can edit product
  def can_edit_product?(product)
    logged_in? && (current_user == product.user || current_user.admin?)
  end
  helper_method :can_edit_product?
end