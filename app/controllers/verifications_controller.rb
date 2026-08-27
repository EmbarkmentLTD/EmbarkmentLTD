class VerificationsController < ApplicationController
  include RateLimitable
  rate_limit max: 10, within: 1.hour
  before_action :enforce_rate_limit, only: :resend
  before_action :authenticate_user!
  before_action :redirect_if_verified, except: [ :show ]

  def show
    # Show verification page
  end

  def verify
    success, message = current_user.verify_email(params[:verification_code])

    if success
      if current_user.email_verified_at.nil?
        current_user.update_columns(
          email_verified_at: Time.current,
          email_verification_code: nil,
          verification_attempts: 0,
          updated_at: Time.current
        )
      end
      current_user.reload
      sign_in(current_user, bypass: true)
      redirect_to root_path, notice: message
    else
      flash.now[:alert] = message
      render :show
    end
  end

  def resend
    unless current_user.can_resend_verification?
      flash[:alert] = "Please wait before requesting a new code."
      redirect_to verification_path
      return
    end

    if current_user.send_verification_code
      flash[:notice] = "A new verification code has been sent to your email."
    else
      flash[:alert] = "Unable to send verification code right now. Please try again shortly."
    end
    redirect_to verification_path
  end

  private

  def redirect_if_verified
    if current_user.email_verified?
      redirect_to root_path, notice: "Your email is already verified!"
    end
  end
end
