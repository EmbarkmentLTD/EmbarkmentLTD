# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  default from: "EmbarkmentLTD <info@embarkment.co.uk>"

  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Welcome to EmbarkmentLTD!"
    )
  end

  def verification_email(user)
    @user = user
    @verification_code = user.email_verification_code
    @verification_url = verification_url

    mail(
      to: @user.email,
      subject: "Verify Your Email Address - EmbarkmentLTD"
    )
  end

  def verification_reminder(user)
    @user = user
    @verification_url = verification_url

    mail(
      to: @user.email,
      subject: "Complete Your Email Verification"
    )
  end

  private

#   def verification_url
#     Rails.application.routes.url_helpers.verification_url(host: host, protocol: protocol)
#   end

#   def host
#     Rails.env.production? ? 'embarkment.co.uk' : 'localhost:3000'
#   end

#   def protocol
#   Rails.env.production? ? 'https' : 'http'
# end

def verification_url
  Rails.application.routes.url_helpers.verification_url(
    Rails.application.config.action_mailer.default_url_options
  )
end
end
