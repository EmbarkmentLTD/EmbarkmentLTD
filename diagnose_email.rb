# diagnose_email.rb
puts "=== Email Configuration Diagnostic ==="

# Test 1: Check environment variables
puts "\n1. Environment Variables:"
puts "   SMTP_USERNAME: #{ENV['SMTP_USERNAME'] || 'NOT SET'}"
puts "   SMTP_PASSWORD: #{ENV['SMTP_PASSWORD'] ? 'SET (hidden)' : 'NOT SET'}"
puts "   PRODUCTION_DOMAIN: #{ENV['PRODUCTION_DOMAIN'] || 'NOT SET'}"

# Test 2: Test GoDaddy SMTP with different ports
ports = [465, 587, 25]
puts "\n2. Testing GoDaddy SMTP ports:"

ports.each do |port|
  puts "\n   Testing port #{port}..."
  begin
    require 'net/smtp'
    
    # Try connection without authentication first
    Timeout.timeout(5) do
      socket = TCPSocket.new('smtpout.secureserver.net', port)
      puts "   ✅ Port #{port}: TCP connection successful"
      socket.close
    end
  rescue => e
    puts "   ❌ Port #{port}: #{e.message}"
  end
end

# Test 3: Test with correct GoDaddy settings
puts "\n3. Testing full SMTP authentication..."

require 'mail'

# GoDaddy's recommended settings
Mail.defaults do
  delivery_method :smtp, {
    address: 'smtpout.secureserver.net',
    port: 465,
    domain: 'llw-cs.com',
    user_name: 'company@llw-cs.com',
    password: 'Consultancy25$',
    authentication: 'plain',
    ssl: true,
    tls: true,
    enable_starttls_auto: false,
    openssl_verify_mode: 'none'
  }
end

begin
  mail = Mail.new do
    from    'company@llw-cs.com'
    to      'company@llw-cs.com'  # Send to yourself first
    subject 'GoDaddy Diagnostic Test'
    body    'Testing GoDaddy SMTP settings'
  end
  
  mail.deliver!
  puts "   ✅ Email sent successfully!"
  
rescue Net::SMTPAuthenticationError => e
  puts "   ❌ Authentication failed: #{e.message}"
  puts "   This means your username/password are incorrect."
  puts "   Check:"
  puts "   1. Username should be FULL email: company@llw-cs.com"
  puts "   2. Password is correct for company@llw-cs.com"
  puts "   3. Account exists and is active"
  
rescue => e
  puts "   ❌ Error: #{e.class}: #{e.message}"
end