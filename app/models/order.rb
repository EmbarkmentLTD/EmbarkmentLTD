class Order < ApplicationRecord

  STATUSES = ['pending', 'confirmed', 'shipped', 'delivered', 'cancelled'].freeze
  
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :shipping_address, presence: true

  before_validation :calculate_total, on: :create
  before_validation :set_default_status, on: :create

  # Add this scope
  scope :completed_this_week, -> { where(status: ['delivered', 'completed', 'confirmed']).where('updated_at >= ?', 1.week.ago) }

  def calculate_total
    self.total_amount = order_items.sum(&:subtotal)
  end

  def set_default_status
    self.status ||= 'pending'
  end

  def confirm!
    update(status: 'confirmed')
    order_items.each do |item|
      item.product.reduce_stock(item.quantity)
    end
  end

  def can_cancel?
    ['pending', 'confirmed'].include?(status)
  end

  def pending?
    status == 'pending'
  end

  def confirmed?
    status == 'confirmed'
  end

  def shipped?
    status == 'shipped'
  end

  def delivered?
    status == 'delivered'
  end

  def cancelled?
    status == 'cancelled'
  end
end