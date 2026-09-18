require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "verification email includes the code and verification link" do
    user = User.create!(
      name: "Mailer User",
      email: "mailer.user.#{SecureRandom.hex(4)}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "buyer",
      location: "Lagos"
    )
    user.update!(email_verification_code: "123456", email_verification_sent_at: Time.current)

    mail = UserMailer.verification_email(user)

    assert_equal [ user.email ], mail.to
    assert_equal "Verify Your Email Address - EmbarkmentLTD", mail.subject
    assert_includes mail.text_part.body.decoded, "123456"
    assert_includes mail.text_part.body.decoded, "http://example.com/verify"
    assert_includes mail.html_part.body.decoded, "123456"
    assert_includes mail.html_part.body.decoded, "http://example.com/verify"
  end

  test "welcome email renders a friendly onboarding message" do
    user = User.create!(
      name: "Welcome User",
      email: "welcome.user.#{SecureRandom.hex(4)}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "buyer",
      location: "Lagos"
    )

    mail = UserMailer.welcome_email(user)

    assert_equal [ user.email ], mail.to
    assert_equal "Welcome to EmbarkmentLTD!", mail.subject
    assert_includes mail.text_part.body.decoded, "Welcome to EmbarkmentLTD"
    assert_includes mail.html_part.body.decoded, "Welcome to EmbarkmentLTD"
  end
end
