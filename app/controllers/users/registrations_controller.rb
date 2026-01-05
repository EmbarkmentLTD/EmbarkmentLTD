class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :location, :role])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :location, :avatar, :role])
  end

  def after_sign_up_path_for(resource)
    products_path
  end

  def after_update_path_for(resource)
    profile_path
  end

  def after_sign_up_path_for(resource)
  verification_path # Redirect to verification page instead of products
end
end