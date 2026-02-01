class QuotationRequest < ApplicationRecord
  belongs_to :user
  has_many :quotation_items, dependent: :destroy

  validates :contact_name, :contact_email, :contact_phone, presence: true
end
