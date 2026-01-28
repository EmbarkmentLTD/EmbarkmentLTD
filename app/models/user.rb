class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :products, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_items, through: :orders


 has_many :sent_messages, class_name: "SupportMessage",
           foreign_key: "sender_id",
           dependent: :destroy,
           inverse_of: :sender

  has_many :received_messages, class_name: "SupportMessage",
           foreign_key: "receiver_id",
           dependent: :destroy,
           inverse_of: :receiver

  before_create :generate_serial_number

  # Keep Devise validations but add extra validation
  validates :email,
    'valid_email_2/email': {
      disposable: { message: "Temporary/disposable emails are not allowed" },
      mx: false,         # Don't check MX records (faster)
      disallow_subaddressing: false  # Allow plus addressing (user+tag@gmail.com)
    }

  validates :name, presence: true
  validates :location, presence: true
  validates :email_verification_code, length: { is: 6 }, allow_nil: true

  after_initialize :set_defaults

  has_one_attached :avatar

  ROLES = [ "buyer", "supplier", "admin", "support" ].freeze

  # Add this scope for the product owner dropdown
  scope :suppliers, -> { where(role: [ "supplier", "admin" ]) }
  scope :support_staff, -> { where(role: [ "support", "admin" ]) }
  scope :active_this_week, -> { where("updated_at >= ?", 1.week.ago) }

  # Add these constants
  VERIFICATION_CODE_EXPIRY = 1.hour
  MAX_VERIFICATION_ATTEMPTS = 5
  REMINDER_DELAY = 24.hours


  def support?
    role == "support"
  end

  def can_chat_with_support?
    buyer? || supplier?
  end

  def can_chat_with_users?
    admin? || support?
  end

  def unread_support_messages
    SupportMessage.unread_by(self)
  end

  def unread_messages_from(user)
    received_messages.where(sender: user, read_at: nil).count
  end

  def unread_support_messages_count
    unread_support_messages.count
  end

  def support_conversations
    # Get users this user has chatted with
    if support? || admin?
      # Support users see conversations with all users
      User.where(id: sent_messages.select(:receiver_id))
          .or(User.where(id: received_messages.select(:sender_id)))
          .distinct
          .where.not(id: id)
    else
      # Regular users see conversations with support staff
      User.where(id: sent_messages.where(receiver: User.support_staff).select(:receiver_id))
          .or(User.where(id: received_messages.where(sender: User.support_staff).select(:sender_id)))
          .distinct
    end
  end

  def latest_support_message_with(user)
    SupportMessage.between(self, user).order(created_at: :desc).first
  end

  def support_conversation_with(user)
    SupportMessage.between(self, user).order(created_at: :asc)
  end


  # Add these methods to calculate total sales and average rating
  def total_sales
    products.joins(:order_items).sum("order_items.quantity * order_items.unit_price")
  end

  def average_rating
    products.joins(:reviews).average("reviews.rating") || 0
  end

  def supplier?
    role == "supplier"
  end

  def buyer?
    role == "buyer"
  end

  def admin?
    role == "admin"
  end

  def can_supply?
    supplier? || admin?
  end

  def sold_products
    products
  end

  def can_review?(product)
  return false unless product.present?
  return false unless product.is_a?(Product)
  return false if product.user == self # Can't review own product

  orders.joins(:order_items)
        .where(order_items: { product_id: product.id })
        .where(status: "delivered")
        .any?
  end

  def can_manage_product?(product)
    admin? || (supplier? && product.user == self)
  end

  def can_manage_products?
    admin? || supplier?
  end

  # Verification status methods
  def email_verified?
    email_verified_at.present?
  end

  def verification_code_expired?
    email_verification_sent_at.present? &&
    email_verification_sent_at < VERIFICATION_CODE_EXPIRY.ago
  end

  def can_resend_verification?
    email_verification_sent_at.nil? ||
    email_verification_sent_at < 2.minutes.ago
  end

  def needs_verification_reminder?
    !email_verified? &&
    (last_verification_reminder_at.nil? ||
     last_verification_reminder_at < REMINDER_DELAY.ago)
  end

  # Generate and send verification code
  def send_verification_code
    return false unless can_resend_verification?

    # Generate 6-digit code
    self.email_verification_code = rand(100000..999999).to_s
    self.email_verification_sent_at = Time.current
    self.verification_attempts = 0
    save!

    # Send verification email
    UserMailer.verification_email(self).deliver_now

    true
  end

  def send_welcome_email
    return unless Rails.env.production?
    UserMailer.welcome_email(self).deliver_now
  end

  def send_verification_reminder
    return false unless needs_verification_reminder?

    self.last_verification_reminder_at = Time.current
    save!

    UserMailer.verification_reminder(self).deliver_now
    true
  end

  # Verify email with code
  def verify_email(code)
    # Check if verification attempts exceeded
    if verification_attempts.to_i >= MAX_VERIFICATION_ATTEMPTS
      return false, "Too many verification attempts. Please request a new code."
    end

    # Check if code is expired
    if verification_code_expired?
      return false, "Verification code has expired. Please request a new one."
    end

    # Check if code matches
    if email_verification_code == code.to_s
      update_columns(
        email_verified_at: Time.current,
        email_verification_code: nil,
        verification_attempts: 0,
        updated_at: Time.current
      )

      # If there was an unverified email change, update it
      if unverified_email.present?
        update(email: unverified_email, unverified_email: nil)
      end

      [ true, "Email verified successfully!" ]
    else
      # Increment verification attempts
      increment!(:verification_attempts)

      attempts_left = MAX_VERIFICATION_ATTEMPTS - verification_attempts
      [ false, "Invalid verification code. #{attempts_left} attempts remaining." ]
    end
  end

  def verified_badge
    if email_verified?
      '<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
        </svg>
        Verified
      </span>'.html_safe
    else
      '<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
        </svg>
        Unverified
      </span>'.html_safe
    end
  end

  # Restrict features for unverified users
  def can_chat?
    email_verified?
  end

  def can_order?
    email_verified?
  end

  private

  def set_defaults
    self.role ||= "buyer"
  end

  def generate_serial_number
    self.serial_number = SerialNumberGenerator.generate_for("user")
  end

  # Add callbacks to send emails after user creation
  # after_create :send_initial_emails
  after_commit :send_initial_emails, on: :create
  after_update :send_verification_for_email_change, if: :saved_change_to_email?

  def send_initial_emails
    # Send welcome email
    send_welcome_email

    # Send verification code (only for non-admin users)
    if !admin? && !support?
      send_verification_code
    end
  end

  def send_verification_for_email_change
    # When email changes, store unverified email and send verification
    update_columns(
    unverified_email: email,
    email: email_before_last_save,
    email_verified_at: nil,
    email_verification_code: nil,
    email_verification_sent_at: nil,
    verification_attempts: 0
  )

  send_verification_code
  end

  # Set default for verification_attempts
  after_initialize :set_verification_defaults

  def set_verification_defaults
    self.verification_attempts ||= 0
  end
end
