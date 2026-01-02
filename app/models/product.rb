class Product < ApplicationRecord
  belongs_to :user
  before_create :generate_serial_number
  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many_attached :images

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true
  validates :unit, presence: true
  validates :location, presence: true
  validate :validate_images
  validate :must_have_at_least_one_image, on: :create

  CATEGORIES = {
    'fruits' => 'Fruits',
    'vegetables' => 'Vegetables', 
    'grains' => 'Grains',
    'herbs' => 'Herbs',
    'nuts' => 'Nuts',
    'dairy' => 'Dairy',
    'meat' => 'Meat',
    'other' => 'Other'
  }.freeze

  UNITS = ['lb', 'kg', 'oz', 'piece', 'dozen', 'bunch', 'bag', 'box'].freeze

  scope :organic, -> { where(is_organic: true) }
  scope :in_stock, -> { where('stock_quantity > 0') }
  scope :featured, -> { where(featured: true) }
  scope :by_category, ->(category) { where(category: category) }
  scope :search, ->(query) { 
    where('name ILIKE ? OR description ILIKE ? OR location ILIKE ?', 
          "%#{query}%", "%#{query}%", "%#{query}%") 
  }
   # Add these scopes and methods
  scope :active, -> { where('stock_quantity > 0') }
  scope :verified, -> { where(verified: true) }

  # Add verified attribute if not exists
  attribute :verified, :boolean, default: false

  def in_stock?
    stock_quantity.to_i > 0
  end

  def primary_image
    images.first
  end

  def category_icon
    case category
    when 'fruits' then '🍎'
    when 'vegetables' then '🥕'
    when 'grains' then '🌾'
    when 'herbs' then '🌿'
    when 'nuts' then '🥜'
    when 'dairy' then '🥛'
    when 'meat' then '🥩'
    else '🌱'
    end
  end

  def category_color
    case category
    when 'fruits' then 'bg-red-100 text-red-800'
    when 'vegetables' then 'bg-green-100 text-green-800'
    when 'grains' then 'bg-yellow-100 text-yellow-800'
    when 'herbs' then 'bg-blue-100 text-blue-800'
    else 'bg-gray-100 text-gray-800'
    end
  end

  def sold_by
    user.name
  end

  # def update_average_rating
  #   if reviews.any?
  #     update(average_rating: reviews.average(:rating), reviews_count: reviews.count)
  #   else
  #     update(average_rating: 0, reviews_count: 0)
  #   end
  # end

  # def reduce_stock(quantity)
  #   update(stock_quantity: stock_quantity - quantity)
  # end

  def update_average_rating
  if reviews.any?
    average = reviews.average(:rating)
    # Always ensure we have a numeric value
    new_rating = average.present? ? average.round(1) : 0.0
    update_columns(
      average_rating: new_rating,
      reviews_count: reviews.count
    )
  else
    update_columns(
      average_rating: 0.0,
      reviews_count: 0
    )
  end
end

  def validate_images
    return unless images.attached?
    
    images.each do |image|
      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "is too large (max 5MB per image)")
      end
      
      unless image.blob.content_type.starts_with?('image/')
        errors.add(:images, "must be an image file")
      end
    end
    
    if images.count > 5
      errors.add(:images, "cannot exceed 5 images")
    end
  end

  def average_rating
    read_attribute(:average_rating) || 0.0
  end

  def reviews_count
    read_attribute(:reviews_count) || 0
  end

  def display_rating
    average_rating.present? ? average_rating.round(1) : 0
  end

  def has_ratings?
    average_rating.present? && average_rating > 0
  end

  def star_rating
    average_rating.present? ? average_rating.floor : 0
  end

  private

  def generate_serial_number
    self.serial_number = SerialNumberGenerator.generate_for('product')
  end

  def must_have_at_least_one_image
    if images.attached? == false || images.count.zero?
      errors.add(:images, "must have at least one image")
    end
  end

end
