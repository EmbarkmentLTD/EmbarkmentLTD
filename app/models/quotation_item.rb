class QuotationItem < ApplicationRecord
  belongs_to :quotation_request
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }
end
