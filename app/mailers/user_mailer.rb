# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: 'EmbarkmentLTD <company@llw-cs.com>'

  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: 'Welcome to EmbarkmentLTD!'
    )
  end
  
  def verification_email(user)
    @user = user
    @verification_code = user.email_verification_code
    @verification_url = verification_url
    
    mail(
      to: @user.email,
      subject: 'Verify Your Email Address - EmbarkmentLTD'
    )
  end
  
  def verification_reminder(user)
    @user = user
    @verification_url = verification_url
    
    mail(
      to: @user.email,
      subject: 'Complete Your Email Verification'
    )
  end
  
  private
  
  def verification_url
    Rails.application.routes.url_helpers.verification_url(host: host)
  end
  
  def host
    Rails.env.production? ? 'llw-cs.com' : 'localhost:3000'
  end
end