class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :rating, presence: true,
                     numericality: { only_integer: true,
                     greater_than: 0, 
                     less_than_or_equal_to: 5 }
  validates :comment, presence: true, length: { minimum: 10 }

  after_save :update_product_rating
  after_destroy :update_product_rating

  # Add flagged attribute if not exists
  attribute :flagged, :boolean, default: false


  private

  def update_product_rating
     # Safe update without raising errors
    product.update_average_rating if product&.persisted?
  end
end
