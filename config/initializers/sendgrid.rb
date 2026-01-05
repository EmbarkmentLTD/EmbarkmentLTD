# Load only if API key exists
if ENV['SENDGRID_API_KEY'].present?
  require 'sendgrid-ruby'
  require 'sendgrid_actionmailer'
  
  # Register the delivery method
  ActionMailer::Base.add_delivery_method(
    :sendgrid_actionmailer,
    SendGridActionMailer::DeliveryMethod,
    api_key: ENV['SENDGRID_API_KEY']
  )
end