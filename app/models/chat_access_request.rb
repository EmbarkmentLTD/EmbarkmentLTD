class ChatAccessRequest < ApplicationRecord
  belongs_to :requester, polymorphic: true
  belongs_to :target, polymorphic: true

  STATUSES = %w[pending approved rejected].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :requester_id, presence: true
  validates :target_id, presence: true
  validates :requester_type, presence: true
  validates :target_type, presence: true
  validates :requester_id, uniqueness: {
    scope: %i[requester_type target_type target_id],
    message: "already has a chat access request for this contact"
  }

  scope :approved, -> { where(status: "approved") }
  scope :pending, -> { where(status: "pending") }

  def approved?
    status == "approved"
  end

  def pending?
    status == "pending"
  end

  def rejected?
    status == "rejected"
  end

  def self.approved_for?(requester, target)
    return false if requester.blank? || target.blank?
    return true if requester.is_a?(User) && (requester.admin? || requester.support?)

    where(requester: requester, target: target, status: "approved").exists?
  end
end
