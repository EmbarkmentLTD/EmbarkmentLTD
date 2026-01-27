# test_mail_gem.rb
require 'mail'

# Configure mail gem
Mail.defaults do
  delivery_method :smtp, {
    address: 'smtp.office365.com',
    port: 587,
    domain: 'llw-cs.com',
    user_name: 'company@llw-cs.com',
    password: 'Consultancy25$',
    authentication: 'login',
    enable_starttls_auto: true,
    openssl_verify_mode: 'none'
  }
end

puts "Testing email with 'mail' gem..."

begin
  mail = Mail.new do
    from    'EmbarkmentLTD <company@llw-cs.com>'
    to      'Adesinaadewale28@yahoo.com'
    subject 'Test from mail gem'
    body    'This is a test using the mail gem instead of Rails Net::SMTP'
  end

  puts "Sending email..."
  mail.deliver!
  puts "✅ Email sent successfully using mail gem!"

rescue => e
  puts "❌ Error: #{e.message}"
  puts "Backtrace: #{e.backtrace.first(5).join("\n")}"
end
