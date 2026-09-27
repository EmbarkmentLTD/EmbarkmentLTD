# app/models/support_message.rb
class SupportMessage < ApplicationRecord
  belongs_to :sender, polymorphic: true
  belongs_to :receiver, polymorphic: true

  # Scopes
  scope :between, ->(user1, user2) {
    where("(sender_id = ? AND sender_type = 'User' AND receiver_id = ? AND receiver_type = 'User') OR
           (sender_id = ? AND sender_type = 'User' AND receiver_id = ? AND receiver_type = 'User')",
           user1.id, user2.id, user2.id, user1.id)
  }

  scope :for_user, ->(user) {
    where("(sender_id = ? AND sender_type = 'User') OR (receiver_id = ? AND sender_type = 'User')",
           user.id, user.id)
  }

  # Fixed scope for unread messages
  scope :unread_by, ->(user) {
    where("(receiver_id = ? AND receiver_type = ? AND read_at IS NULL)",
          user.id, "User")
  }

  # Alternative simpler scope
  scope :received_by, ->(user) {
    where(receiver_id: user.id, receiver_type: "User")
  }

  scope :sent_by, ->(user) {
    where(sender_id: user.id, sender_type: "User")
  }

  # Validations - MAKE SURE THESE ARE CORRECT
  validates :message, presence: true
  validates :sender_id, presence: true
  validates :sender_type, presence: true
  validates :receiver_id, presence: true
  validates :receiver_type, presence: true

  # Mark as read
  def mark_as_read!
    update_column(:read_at, Time.current) unless read_at
  end

  def read?
    read_at.present?
  end

  def unread?
    read_at.nil?
  end

  # Helper methods
  def other_user(current_user)
    if sender == current_user
      receiver
    else
      sender
    end
  end

  def is_support_message?(current_user)
    other_user(current_user).support? || other_user(current_user).admin?
  end

  after_create_commit :broadcast_to_receiver

  # Add this method to ensure sender/receiver types are set
  before_validation :set_polymorphic_types

  private

  def broadcast_to_receiver
    return unless sender.is_a?(User) && receiver.is_a?(User)

    message_payload = {
      id: id,
      message: message,
      sender: { id: sender.id, name: sender.name },
      receiver: { id: receiver.id, name: receiver.name },
      created_at: created_at.iso8601
    }

    ActionCable.server.broadcast("chat_user_#{receiver.id}", { type: "new_message", message: message_payload, sender_id: sender.id })

    unread_by_sender = SupportMessage.where(
      receiver_id: receiver.id, receiver_type: "User", read_at: nil
    ).group(:sender_id).count

    ActionCable.server.broadcast("chat_user_#{receiver.id}", {
      type: "unread_update",
      total_unread: unread_by_sender.values.sum,
      unread_by_sender: unread_by_sender,
      latest_unread_sender_id: sender.id
    })
  end

  def set_polymorphic_types
    self.sender_type = "User" if sender_type.blank? && sender.present?
    self.receiver_type = "User" if receiver_type.blank? && receiver.present?
  end
end
