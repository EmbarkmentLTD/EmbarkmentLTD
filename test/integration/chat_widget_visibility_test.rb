require "test_helper"

class ChatWidgetVisibilityTest < ActionDispatch::IntegrationTest
  setup do
    suffix = SecureRandom.hex(4)

    @support = User.create!(
      name: "Support User",
      email: "support.chat.#{suffix}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "support",
      location: "Lagos"
    )

    @buyer = User.create!(
      name: "Buyer User",
      email: "buyer.chat.#{suffix}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "buyer",
      location: "Lagos"
    )
    @buyer.update!(email_verified_at: Time.current)
  end

  test "verified buyer sees the live chat widget and can send a support message" do
    before_count = SupportMessage.count

    post "/login", params: { user: { email: @buyer.email, password: "Password123!" } }
    assert_includes [ 200, 302, 303 ], response.status

    @buyer.reload
    code = @buyer.generate_sign_in_code
    post "/sign_in_verification", params: { sign_in_code: code }
    assert_includes [ 200, 302, 303 ], response.status

    get "/"
    assert_response :success
    assert_includes response.body, "id=\"chat-widget\""
    assert_includes response.body, "Select who to message..."

    post "/support_chat_messages", params: {
      receiver_id: @support.id,
      message: "Hello support team, I need help with my order."
    }

    assert_response :success
    assert_equal true, JSON.parse(response.body)["success"]
    assert_equal before_count + 1, SupportMessage.count
  end
end
