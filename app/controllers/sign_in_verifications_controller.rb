class SignInVerificationsController < ApplicationController
  skip_before_action :check_verification, raise: false
  skip_before_action :verify_authenticity_token, only: [ :create, :resend ], raise: false, prepend: true

  before_action :load_pending_user

  def show
  end

  def create
    submitted_code = params[:sign_in_code].to_s

    # verify_sign_in_code now marks code as used (one-time) before returning true
    if @user.verify_sign_in_code(submitted_code)
      # Code was valid and marked as used
      session.delete(:pending_sign_in_id)
      session.delete(:pending_sign_in_code)
      sign_in @user unless user_signed_in?
      if @user.email_verified?
        redirect_to products_path, notice: "Welcome back, #{@user.name}!"
      else
        @user.send_verification_code(force: true)
        redirect_to verification_path, notice: "We sent your account verification code to #{@user.email}. Check your inbox to verify your account."
      end
    else
      flash.now[:alert] = "Invalid or expired code. Please try again."
      render :show, status: :unprocessable_entity
    end
  end

  def resend
    session[:pending_sign_in_code] = @user.generate_sign_in_code
    UserMailer.sign_in_code(@user).deliver_later
    redirect_to sign_in_verification_path, notice: "A new code has been sent to your email."
  rescue => e
    Rails.logger.error("Sign-in code resend failed for user #{@user&.id}: #{e.class} #{e.message}")
    redirect_to sign_in_verification_path, alert: "Unable to resend code right now. Please try again in a moment."
  end

  private

  def load_pending_user
    @user = User.find_by(id: session[:pending_sign_in_id])
    @user ||= current_user if user_signed_in?

    if @user.nil? && params[:sign_in_code].present?
      @user = User.where.not(sign_in_code: [ nil, "" ]).find do |candidate|
        candidate.verify_sign_in_code(params[:sign_in_code])
      end
      session[:pending_sign_in_id] = @user.id if @user
    end

    unless @user
      redirect_to new_user_session_path, alert: "Session expired. Please sign in again."
      nil
    end
  end
end
