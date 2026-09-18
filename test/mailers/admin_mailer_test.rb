require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "new chat message goes to all admins" do
    admin_one = User.create!(
      name: "Admin One",
      email: "admin.one.#{SecureRandom.hex(4)}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "admin",
      location: "Lagos",
      email_verified_at: Time.current
    )
    admin_two = User.create!(
      name: "Admin Two",
      email: "admin.two.#{SecureRandom.hex(4)}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "admin",
      location: "Lagos",
      email_verified_at: Time.current
    )

    mail = AdminMailer.new_chat_message(
      name: "Visitor",
      email: "visitor@example.com",
      message: "Hello there",
      ip_address: "127.0.0.1",
      page_url: "/",
      user_agent: "Mozilla/5.0"
    )

    assert_equal [ admin_one.email, admin_two.email ].sort, mail.to.sort
    assert_equal "💬 New Chat: Visitor", mail.subject
    assert_includes mail.body.decoded, "Hello there"
    assert_includes mail.body.decoded, "visitor@example.com"
  end

  test "support reply targets the original user" do
    support = User.create!(
      name: "Support Agent",
      email: "support.agent.#{SecureRandom.hex(4)}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "support",
      location: "Lagos",
      email_verified_at: Time.current
    )
    user = User.create!(
      name: "Support User",
      email: "support.user.#{SecureRandom.hex(4)}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "buyer",
      location: "Lagos",
      email_verified_at: Time.current
    )
    message = SupportMessage.create!(sender: support, receiver: user, message: "We have replied", read_at: Time.current)

    mail = AdminMailer.support_reply(user, message)

    assert_equal [ user.email ], mail.to
    assert_equal "Support Response from #{support.name}", mail.subject
    assert_includes mail.text_part.body.decoded, "We have replied"
    assert_includes mail.text_part.body.decoded, support.name
  end
end
