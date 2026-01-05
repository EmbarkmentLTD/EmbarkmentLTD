# test_godaddy_simple.rb
require 'mail'

puts "Testing GoDaddy SMTP - Standalone Test"
puts "=" * 50

# Configuration
smtp_config = {
  address: 'smtpout.secureserver.net',
  port: 587,
  domain: 'llw-cs.com',
  user_name: 'company@llw-cs.com',
  password: 'Consultancy25$',
  authentication: :plain,
  enable_starttls_auto: true,
  openssl_verify_mode: 'none'
}

# Configure Mail
Mail.defaults do
  delivery_method :smtp, smtp_config
end

puts "SMTP Configuration:"
smtp_config.each { |k, v| puts "  #{k}: #{v}" }
puts ""

# Test email
test_email = 'konenpatricia0@gmail.com'
verification_code = '856470'  # The code from your console

puts "Sending test email to: #{test_email}"
puts "Verification code: #{verification_code}"
puts ""

begin
  mail = Mail.new do
    from    'company@llw-cs.com'
    to      test_email
    subject 'EmbarkmentLTD - Verification Code Test'
    body    "Your verification code is: #{verification_code}\n\nPlease enter this code at https://llw-cs.com/verify"
  end
  
  puts "Attempting to send..."
  mail.deliver!
  
  puts ""
  puts "✅ SUCCESS: Email sent!"
  puts "Check #{test_email} inbox (and spam folder)"
  puts "Code should arrive within 1-2 minutes"
  
rescue => e
  puts ""
  puts "❌ FAILED: #{e.class}: #{e.message}"
  
  # Try alternative port 465
  puts "\nTrying port 465 (SSL)..."
  begin
    smtp_config[:port] = 465
    smtp_config[:ssl] = true
    smtp_config[:enable_starttls_auto] = false
    
    Mail.defaults { delivery_method :smtp, smtp_config }
    
    mail2 = Mail.new do
      from    'company@llw-cs.com'
      to      test_email
      subject 'EmbarkmentLTD - SSL Test'
      body    "SSL test email"
    end
    
    mail2.deliver!
    puts "✅ SSL email sent via port 465"
  rescue => e2
    puts "❌ SSL also failed: #{e2.message}"
  end
end

puts ""
puts "=" * 50
puts "If emails don't arrive:"
puts "1. Check spam folder"
puts "2. Login to GoDaddy webmail: https://email.secureserver.net"
puts "3. Verify email account exists"
puts "4. Check GoDaddy email sending limits"