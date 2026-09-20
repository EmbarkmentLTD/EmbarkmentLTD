require "test_helper"

class ChatMessageFlowTest < ActionDispatch::IntegrationTest
  setup do
    suffix = SecureRandom.hex(4)

    @support = User.create!(
      name: "Support Flow",
      email: "support.flow.#{suffix}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "support",
      location: "London",
      email_verified_at: Time.current
    )

    @buyer = User.create!(
      name: "Buyer Flow",
      email: "buyer.flow.#{suffix}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "buyer",
      location: "London",
      email_verified_at: Time.current
    )

    @seller = User.create!(
      name: "Seller Flow",
      email: "seller.flow.#{suffix}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "supplier",
      location: "London",
      email_verified_at: Time.current
    )

    @admin = User.create!(
      name: "Admin Flow",
      email: "admin.flow.#{suffix}@gmail.com",
      password: "Password123!",
      password_confirmation: "Password123!",
      role: "admin",
      location: "London",
      email_verified_at: Time.current
    )
  end

  test "verified buyer can send to support" do
    login_as(@buyer)

    before_count = SupportMessage.count

    post support_chat_messages_path, params: {
      receiver_id: @support.id,
      message: "Need support help"
    }, as: :json

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal true, body["success"]
    assert_equal before_count + 1, SupportMessage.count
    assert SupportMessage.exists?(sender: @buyer, receiver: @support, message: "Need support help")
  end

  test "buyer to seller requires support approval and creates pending request" do
    login_as(@buyer)

    before_count = SupportMessage.count

    post support_chat_messages_path, params: {
      receiver_id: @seller.id,
      message: "Can we discuss stock?"
    }, as: :json

    assert_response :forbidden
    body = JSON.parse(response.body)
    assert_equal true, body["requires_approval"]
    assert_equal before_count, SupportMessage.count

    request = ChatAccessRequest.find_by(requester: @buyer, target: @seller)
    assert_not_nil request
    assert_equal "pending", request.status
  end

  test "admin can send to any user without restriction" do
    login_as(@admin)

    before_count = SupportMessage.count

    post support_chat_messages_path, params: {
      receiver_id: @buyer.id,
      message: "Admin update"
    }, as: :json

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal true, body["success"]
    assert_equal before_count + 1, SupportMessage.count
    assert SupportMessage.exists?(sender: @admin, receiver: @buyer, message: "Admin update")
  end

  test "buyer can load conversation history with support" do
    login_as(@buyer)

    SupportMessage.create!(
      sender: @buyer,
      receiver: @support,
      message: "Need pricing details"
    )

    get support_chat_conversation_path(@support), as: :json

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal true, body["success"]
    assert_equal @support.id, body.dig("other_user", "id")
    assert_equal @buyer.id, body.dig("current_user", "id")
    assert body["messages"].any?
  end

  test "buyer loading supplier conversation without approval returns guidance" do
    login_as(@buyer)

    get support_chat_conversation_path(@seller), as: :json

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal false, body["success"]
    assert_equal true, body["access_denied"]
    assert_includes body["message"], "support approval"
  end

  private

  def login_as(user)
    post "/login", params: { user: { email: user.email, password: "Password123!" } }
    user.reload
    code = user.generate_sign_in_code
    post "/sign_in_verification", params: { sign_in_code: code }
    assert_includes [ 200, 302, 303 ], response.status
  end
end
