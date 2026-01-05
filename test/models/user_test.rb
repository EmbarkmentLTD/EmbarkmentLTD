# test/models/user_test.rb
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should send verification code on create' do
    user = User.new(
      name: 'Test User',
      email: 'test@example.com',
      password: 'password123',
      location: 'Test Location'
    )
    
    assert_enqueued_jobs 2 do  # Welcome email + verification email
      user.save!
    end
  end
  
  test 'should verify email with correct code' do
    user = users(:unverified_user)
    code = user.email_verification_code
    
    assert_changes -> { user.reload.email_verified? }, from: false, to: true do
      success, message = user.verify_email(code)
      assert success
      assert_equal 'Email verified successfully!', message
    end
  end
end