# test_verification_system.rb
require_relative 'config/environment'

puts "Testing User Verification System..."

# Create a test user
user = User.create!(
  name: 'Test User',
  email: 'Adesinaadewale28@yahoo.com',
  password: 'TestPassword123',
  location: 'Test City'
)

puts "User created: #{user.email}"

# Test welcome email
puts "\n1. Testing welcome email..."
begin
  UserMailer.welcome_email(user).deliver_now
  puts "✅ Welcome email sent!"
rescue => e
  puts "❌ Welcome email error: #{e.message}"
end

# Test verification email
puts "\n2. Testing verification email..."
begin
  user.send_verification_code
  puts "✅ Verification code generated: #{user.email_verification_code}"
  
  UserMailer.verification_email(user).deliver_now
  puts "✅ Verification email sent!"
rescue => e
  puts "❌ Verification email error: #{e.message}"
end

puts "\nCheck your email at: Adesinaadewale28@yahoo.com"