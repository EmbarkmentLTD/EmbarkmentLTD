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

  test "recipient can recall and read a newly sent support message" do
    login_as(@buyer)

    post support_chat_messages_path, params: {
      receiver_id: @support.id,
      message: "Please confirm my shipment ETA"
    }, as: :json

    assert_response :success
    sender_body = JSON.parse(response.body)
    assert_equal true, sender_body["success"]

    # Switch session to recipient and confirm conversation can be loaded.
    delete destroy_user_session_path
    login_as(@support)

    get support_chat_conversation_path(@buyer), as: :json

    assert_response :success
    recipient_body = JSON.parse(response.body)
    assert_equal true, recipient_body["success"]
    assert_equal @buyer.id, recipient_body.dig("other_user", "id")
    assert recipient_body["messages"].any? { |m| m["message"] == "Please confirm my shipment ETA" }
  end

  test "recipient unread counts include sender for chat widget discovery" do
    login_as(@buyer)

    post support_chat_messages_path, params: {
      receiver_id: @support.id,
      message: "Need help with a delayed delivery"
    }, as: :json
    assert_response :success

    delete destroy_user_session_path
    login_as(@support)

    get support_chat_unread_counts_path, as: :json

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal true, body["success"]
    assert body["total_unread"].to_i >= 1
    assert_equal @buyer.id, body["latest_unread_sender_id"]
    assert body.fetch("unread_by_sender", {}).key?(@buyer.id.to_s)
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
