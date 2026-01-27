# test_office365_fixed.rb
require 'mail'

# Test configuration
puts "=== Testing GoDaddy SMTP ==="

Mail.defaults do
  delivery_method :smtp, {
    address: 'smtpout.secureserver.net',
    port: 465,  # GoDaddy uses port 465 with SSL
    domain: 'llw-cs.com',
    user_name: 'company@llw-cs.com',  # Use FULL email, not just number
    password: 'Consultancy25$',
    authentication: 'plain',
    enable_starttls_auto: false,  # Disable for SSL
    ssl: true,                    # Enable SSL
    tls: true,                    # Enable TLS
    openssl_verify_mode: 'none',
    open_timeout: 30,
    read_timeout: 30
  }
end

begin
  puts "1. Creating email..."
  mail = Mail.new do
    from    'EmbarkmentLTD <company@llw-cs.com>'
    to      'Adesinaadewale28@yahoo.com'
    subject 'GoDaddy SMTP Test'
    body    'Testing GoDaddy SMTP configuration'
  end

  puts "2. Attempting to send..."
  mail.deliver!
  puts "✅ Email sent successfully!"

rescue => e
  puts "❌ Error: #{e.class}: #{e.message}"
  puts "Backtrace:"
  puts e.backtrace.first(3).join("\n")
end
