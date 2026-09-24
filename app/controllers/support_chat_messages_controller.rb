# app/controllers/support_chat_messages_controller.rb
class SupportChatMessagesController < ApplicationController
  include RateLimitable
  rate_limit max: 10, within: 1.hour
  before_action :enforce_rate_limit
  before_action :authenticate_user!, only: [ :conversations, :unread_counts ]

  def create
    if user_signed_in?
      handle_logged_in_user
    else
      handle_guest_user
    end
  end

  def conversations
    other_user_id = params[:id].to_s[/\d+/]
    other_user = User.find_by(id: other_user_id)

    Rails.logger.info("Chat conversations: current_user=#{current_user.id}, other_user_id=#{other_user_id}, found=#{other_user&.id}")

    unless other_user
      render json: {
        success: false,
        message: "Unable to open that conversation right now. Please reselect a contact.",
        messages: []
      }
      return
    end

    unless current_user.can_chat_with?(other_user)
      Rails.logger.warn("Chat not allowed: #{current_user.id} cannot chat with #{other_user.id}")
      render json: {
        success: false,
        access_denied: true,
        message: "This conversation needs support approval before history is available.",
        other_user: {
          id: other_user.id,
          name: other_user.name,
          role: other_user.role
        },
        current_user: {
          id: current_user.id,
          name: current_user.name,
          role: current_user.role
        },
        messages: []
      }
      return
    end

    messages = SupportMessage.between(current_user, other_user).order(created_at: :asc)
    Rails.logger.info("Chat messages loaded: current_user=#{current_user.id}, other_user=#{other_user.id}, count=#{messages.count}")
    messages.where(receiver: current_user, read_at: nil).update_all(read_at: Time.current)

    render json: {
      success: true,
      other_user: {
        id: other_user.id,
        name: other_user.name,
        role: other_user.role
      },
      current_user: {
        id: current_user.id,
        name: current_user.name,
        role: current_user.role
      },
      messages: messages.map { |m|
        {
          id: m.id,
          message: m.message,
          sender: {
            id: m.sender.id,
            name: m.sender.name
          },
          receiver: {
            id: m.receiver.id,
            name: m.receiver.name
          },
          created_at: m.created_at,
          read_at: m.read_at
        }
      }
    }
  end

  def unread_counts
    contact_ids = current_user.chat_contact_options.pluck(:id)

    unread_scope = SupportMessage.where(
      receiver_id: current_user.id,
      receiver_type: "User",
      sender_type: "User",
      read_at: nil
    )

    unread_scope = unread_scope.where(sender_id: contact_ids) if contact_ids.any?

    unread_by_sender = unread_scope.group(:sender_id).count
    latest_unread_sender_id = unread_scope.order(created_at: :desc).limit(1).pluck(:sender_id).first

    render json: {
      success: true,
      total_unread: unread_by_sender.values.sum,
      unread_by_sender: unread_by_sender,
      latest_unread_sender_id: latest_unread_sender_id
    }
  end

  private

  def handle_logged_in_user
    message_text = params[:message].to_s.strip
    if message_text.blank?
      render json: {
        success: false,
        message: "Please type a message before sending."
      }, status: :unprocessable_entity
      return
    end

    receiver = find_receiver_for_logged_in_user
    Rails.logger.info("Chat message create: sender=#{current_user.id}, receiver=#{receiver&.id}, text_length=#{message_text.length}")

    unless receiver
      Rails.logger.warn("Chat message create: receiver not found for user #{current_user.id}")
      render json: {
        success: false,
        message: "Please select who you want to chat with."
      }, status: :unprocessable_entity
      return
    end

    unless current_user.can_chat_with?(receiver)
      Rails.logger.warn("Chat message create: not allowed for #{current_user.id} → #{receiver.id}")
      render json: {
        success: false,
        message: "You are not allowed to chat with this contact."
      }, status: :forbidden
      return
    end

    @message = SupportMessage.create(
      message: message_text,
      sender: current_user,
      receiver: receiver,
      created_at: Time.current,
      updated_at: Time.current
    )

    Rails.logger.info("Chat message create result: id=#{@message.id}, persisted=#{@message.persisted?}, errors=#{@message.errors.full_messages.join(', ')}")

    if @message.persisted?
      if receiver.support? || receiver.admin?
        # Customer sent to support - notify support of new message
        Rails.logger.info("Chat message create: sending new_support_message to #{receiver.id}")
        AdminMailer.new_support_message(receiver, @message).deliver_later
      elsif current_user.support? || current_user.admin?
        # Support sent to customer - notify customer of support reply
        Rails.logger.info("Chat message create: sending support_reply to #{receiver.id}")
        AdminMailer.support_reply(receiver, @message).deliver_later
      end

      render json: {
        success: true,
        message: "Message sent successfully.",
        receiver: {
          id: receiver.id,
          name: receiver.name,
          role: receiver.role
        }
      }
    else
      render json: {
        success: false,
        message: "Failed to send message. Please try again."
      }, status: :unprocessable_entity
    end
  end

  def handle_guest_user
    # Guest user - email only (keep existing functionality)
    chat_data = {
      message: params[:message],
      name: params[:name] || "Guest User",
      email: params[:email] || "no-email@example.com",
      user: nil,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      page_url: request.referer
    }

    if params[:email].blank?
      render json: {
        success: false,
        message: "Please provide your email address."
      }, status: :unprocessable_entity
      return
    end

    AdminMailer.new_chat_message(chat_data).deliver_later

    render json: {
      success: true,
      message: "Thank you! We'll email you shortly."
    }
  end

  def find_receiver_for_logged_in_user
    receiver_id = params[:receiver_id].presence || params[:user_id].presence
    if receiver_id.present?
      User.find_by(id: receiver_id)
    elsif current_user.admin? || current_user.support?
      nil
    else
      User.support_staff.where.not(email_verified_at: nil).order(:id).first || User.admin.first
    end
  end
end
