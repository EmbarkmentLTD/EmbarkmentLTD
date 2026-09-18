class Users::SessionsController < Devise::SessionsController
  include RateLimitable
  rate_limit max: 20, within: 30.minutes
  prepend_before_action :enforce_rate_limit, only: :create
  skip_before_action :verify_authenticity_token, only: :create, raise: false, prepend: true

  def create
    email = params.dig(:user, :email).to_s.strip.downcase
    password = params.dig(:user, :password).to_s

    self.resource = resource_class.find_for_database_authentication(email: email)

    if resource.present? && resource.valid_password?(password)
      session[:pending_sign_in_id] = resource.id
      sign_in(resource_name, resource)

      set_flash_message!(:notice, :signed_in) if is_flashing_format?
      respond_with resource, location: sign_in_verification_path
      return
    end

    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with resource, location: new_session_path(resource_name)
  end

  protected

  def after_sign_in_path_for(resource)
    sign_in_verification_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
