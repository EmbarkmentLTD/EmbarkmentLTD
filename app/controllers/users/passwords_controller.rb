class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      flash.now[:alert] = resource.errors.full_messages.to_sentence
      respond_with(resource, status: :unprocessable_entity)
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)

      if Devise.sign_in_after_reset_password
        set_flash_message!(:notice, :updated)
        sign_in(resource_name, resource)
        respond_with resource, location: after_resetting_password_path_for(resource)
      else
        set_flash_message!(:notice, :updated_not_active)
        respond_with resource, location: new_session_path(resource_name)
      end
    else
      set_minimum_password_length
      flash.now[:alert] = resource.errors.full_messages.to_sentence
      respond_with resource, status: :unprocessable_entity
    end
  end
end
