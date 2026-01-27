# test_web_interface.rb
require_relative 'config/environment'

# Set to inline processing
ActiveJob::Base.queue_adapter = :inline

# Get or create test user
user = User.find_by(email: 'bettythomp0@gmail.com') || User.last

puts "Testing web interface flow..."
puts "User: #{user.email}"

# Simulate what happens when user clicks "Resend"
if user.can_resend_verification?
  puts "Sending verification code..."
  user.send_verification_code
  puts "✅ Code sent: #{user.email_verification_code}"
else
  puts "❌ Cannot resend yet"
end
