class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def after_sign_in_path_for(resource)
    products_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end