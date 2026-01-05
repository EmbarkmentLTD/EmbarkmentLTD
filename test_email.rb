# test_godaddy_smtp.rb
require 'mail'

puts "Testing GoDaddy SMTP Configuration..."
puts "=" * 50

# Configure Mail gem with GoDaddy settings
Mail.defaults do
  delivery_method :smtp, {
    address: 'smtpout.secureserver.net',
    port: 587,
    domain: 'llw-cs.com',
    user_name: 'company@llw-cs.com',
    password: 'Consultancy25$',
    authentication: :plain,
    enable_starttls_auto: true,
    openssl_verify_mode: 'none'
  }
end

begin
  puts "1. Creating test email..."
  mail = Mail.new do
    from    'company@llw-cs.com'
    to      'konenpatricia0@gmail.com'  # Change to your test email
    subject 'GoDaddy SMTP Test'
    body    'This is a test email sent via GoDaddy SMTP server.'
  end
  
  puts "2. Attempting to send..."
  mail.deliver!
  
  puts "✅ SUCCESS: Email sent via GoDaddy SMTP!"
  puts "Check your inbox (and spam folder)"
  
rescue => e
  puts "❌ FAILED: #{e.class}: #{e.message}"
  puts "\nTroubleshooting steps:"
  puts "1. Verify 'company@llw-cs.com' exists in GoDaddy"
  puts "2. Verify password is correct"
  puts "3. Try port 465 with ssl: true instead"
  puts "4. Check GoDaddy email webmail interface"
end