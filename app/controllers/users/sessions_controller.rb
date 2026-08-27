class Users::SessionsController < Devise::SessionsController
  include RateLimitable
  rate_limit max: 20, within: 30.minutes
  before_action :enforce_rate_limit, only: :create

  protected

  def after_sign_in_path_for(resource)
    products_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
