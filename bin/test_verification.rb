# bin/test_verification.rb
require_relative '../config/environment'

begin
  # Check if UserMailer exists
  UserMailer
rescue NameError
  puts "⚠️  UserMailer not found. Creating test user without emails..."
  
  # Create a test user without triggering callbacks
  user = User.new(
    name: 'Test Verification',
    email: "test-verification-#{Time.now.to_i}@example.com",
    password: 'password123',
    location: 'Test City',
    role: 'buyer'
  )
  
  # Skip callbacks
  User.skip_callback(:create, :after, :send_initial_emails)
  
  if user.save
    # Manually set verification code
    user.update!(
      email_verification_code: '123456',
      email_verification_sent_at: Time.current
    )
    
    puts "✅ User created: #{user.email}"
    puts "📧 Verification code: #{user.email_verification_code}"
    puts "⏰ Code expires at: #{user.email_verification_sent_at + 1.hour}"
    puts "🌐 Verification URL: http://localhost:3000/verify"
  else
    puts "❌ Failed to create user: #{user.errors.full_messages.join(', ')}"
  end
  
  # Restore callbacks
  User.set_callback(:create, :after, :send_initial_emails)
else
  # UserMailer exists, proceed normally
  user = User.create!(
    name: 'Test Verification',
    email: "test-verification-#{Time.now.to_i}@example.com",
    password: 'password123',
    location: 'Test City',
    role: 'buyer'
  )

  puts "✅ User created: #{user.email}"
  puts "📧 Verification code: #{user.email_verification_code}"
  puts "⏰ Code expires at: #{user.email_verification_sent_at + 1.hour}"
  puts "🌐 Verification URL: http://localhost:3000/verify"
  puts "📨 Emails sent: Welcome + Verification"
end