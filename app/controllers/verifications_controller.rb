class VerificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_verified, except: [:show]
  
  def show
    # Show verification page
  end
  
  def verify
    success, message = current_user.verify_email(params[:verification_code])
    
    if success
      redirect_to root_path, notice: message
    else
      flash.now[:alert] = message
      render :show
    end
  end
  
  def resend
    # if current_user.can_resend_verification?
    #   current_user.send_verification_code
    #   flash[:notice] = "New verification code sent to your email!"
    # else
    #   flash[:alert] = "Please wait before requesting a new code."
    # end
    
    # redirect_to verification_path

    current_user.send_verification_code
  # Show code on screen instead of email
  flash[:notice] = "Verification code: #{current_user.email_verification_code}"
  redirect_to verification_path
  end
  
  private
  
  def redirect_if_verified
    if current_user.email_verified?
      redirect_to root_path, notice: "Your email is already verified!"
    end
  end
end