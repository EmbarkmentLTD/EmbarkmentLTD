# app/controllers/support_chat_messages_controller.rb
class SupportChatMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    if user_signed_in?
      handle_logged_in_user
    else
      handle_guest_user
    end
  end
  
  private
  
  def handle_logged_in_user
    # Find or create support conversation
    support_user = find_or_create_support_conversation
    
    # Create message
    @message = SupportMessage.create(
      message: params[:message],
      sender: current_user,
      receiver: support_user,
      created_at: Time.current,
      updated_at: Time.current
    )
    
    if @message.persisted?
      # Notify support user via email
      AdminMailer.new_support_message(support_user, @message).deliver_later
      
      render json: { 
        success: true, 
        message: 'Message sent! Support will respond soon.',
        auto_redirect: false
      }
    else
      render json: { 
        success: false, 
        message: 'Failed to send message. Please try again.' 
      }, status: :unprocessable_entity
    end
  end
  
  def handle_guest_user
    # Guest user - email only (keep existing functionality)
    chat_data = {
      message: params[:message],
      name: params[:name] || 'Guest User',
      email: params[:email] || 'no-email@example.com',
      user: nil,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      page_url: request.referer
    }
    
    if params[:email].blank?
      render json: { 
        success: false, 
        message: 'Please provide your email address.' 
      }, status: :unprocessable_entity
      return
    end
    
    AdminMailer.new_chat_message(chat_data).deliver_later
    
    render json: { 
      success: true, 
      message: 'Thank you! We\'ll email you shortly.'
    }
  end
  
  def find_or_create_support_conversation
    # Check if user already has an open conversation with any support
    existing_support = current_user.support_conversations.first
    
    return existing_support if existing_support
    
    # Assign to available support user (least busy)
    User.support_staff.order('RANDOM()').first || User.admin.first
  end
end