require "test_helper"

class ChatAccessRequestTest < ActiveSupport::TestCase
  test "buyers see only verified support and approved supplier contacts" do
    support = User.create!(name: "Support", email: "support.chat.request@gmail.com", password: "Password123!", password_confirmation: "Password123!", role: "support", location: "Lagos")
    support.update!(email_verified_at: Time.current)
    supplier = User.create!(name: "Supplier", email: "supplier.chat.request@gmail.com", password: "Password123!", password_confirmation: "Password123!", role: "supplier", location: "Lagos")
    supplier.update!(email_verified_at: Time.current)
    buyer = User.create!(name: "Buyer", email: "buyer.chat.request@gmail.com", password: "Password123!", password_confirmation: "Password123!", role: "buyer", location: "Lagos")
    buyer.update!(email_verified_at: Time.current)

    approved = ChatAccessRequest.create!(requester: buyer, target: supplier, status: "approved")

    contacts = buyer.chat_contact_options
    assert_includes contacts.map(&:id), support.id
    assert_includes contacts.map(&:id), supplier.id

    other_buyer = User.create!(name: "Other Buyer", email: "other.buyer.chat.request@gmail.com", password: "Password123!", password_confirmation: "Password123!", role: "buyer", location: "Lagos")
    assert_not_includes contacts.map(&:id), other_buyer.id

    assert buyer.can_chat_with?(supplier)
    assert_not buyer.can_chat_with?(other_buyer)
    assert approved.approved?
  end
end
