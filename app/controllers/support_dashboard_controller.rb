# app/controllers/support_dashboard_controller.rb
class SupportDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_support_access

  def index
    # For support users: show all users they can chat with
    @users = if current_user.admin?
               User.all
    else
               User.where.not(id: current_user.id)  # Support can chat with everyone except themselves
    end

    # FIX: Get unread message counts FOR current_user (messages sent TO support user)
    @unread_counts = {}
    @users.each do |user|
      # Count messages FROM this user TO current_user that are unread
      @unread_counts[user.id] = SupportMessage.where(
        sender_id: user.id,
        sender_type: "User",
        receiver_id: current_user.id,
        receiver_type: "User",
        read_at: nil
      ).count
    end

    respond_to do |format|
      format.html # Renders index.html.erb
      format.json {
        render json: {
          users: @users.as_json(only: [ :id, :name, :email, :role ]),
          unread_counts: @unread_counts,
          current_user_unread: current_user.unread_support_messages_count,
          # ADD THIS: Total unread messages for current user (from all users)
          total_unread_for_current_user: SupportMessage.where(
            receiver_id: current_user.id,
            receiver_type: "User",
            read_at: nil
          ).count
        }
      }
    end
  end

  def conversations
    @other_user = User.find(params[:id])
    @messages = SupportMessage.between(current_user, @other_user).order(created_at: :asc)

    # FIX: Mark messages as read properly - mark messages sent TO current_user as read
    # When support user views conversation, mark messages FROM the other user as read
    @messages.where(
      sender_id: @other_user.id,
      sender_type: "User",
      receiver_id: current_user.id,
      receiver_type: "User",
      read_at: nil
    ).update_all(read_at: Time.current)

    @new_message = SupportMessage.new

    respond_to do |format|
      format.html # Renders conversations.html.erb

      format.json {
        render json: {
          success: true,
          other_user: {
            id: @other_user.id,
            name: @other_user.name,
            email: @other_user.email
          },
          current_user: {
            id: current_user.id,
            name: current_user.name
          },
          messages: @messages.map { |m| {
            id: m.id,
            message: m.message,
            sender: { id: m.sender.id, name: m.sender.name },
            receiver: { id: m.receiver.id, name: m.receiver.name },
            created_at: m.created_at,
            read_at: m.read_at
          }}
        }
      }
    end
  end

  def create_message
    # Get user_id from params - check both locations
    user_id = params[:user_id] || params.dig(:support_message, :user_id)

    unless user_id.present?
      respond_to do |format|
        format.html { redirect_back fallback_location: support_dashboard_path, alert: "Please select a user." }
        format.json { render json: { success: false, message: "Please select a user." }, status: :unprocessable_entity }
      end
      return
    end

    # Get message from params - check multiple locations
    message_text = params[:message] || params.dig(:support_message, :message)

    @message = SupportMessage.new(
      message: message_text,
      sender: current_user,
      receiver: User.find(user_id)
    )

    if @message.save
      # Notify the other user
      send_message_notification(@message)

      respond_to do |format|
        format.html { redirect_to support_conversations_path(id: user_id), notice: "Message sent!" }
        format.json { render json: {
          success: true,
          message: "Message sent!",
          new_message: {
            id: @message.id,
            message: @message.message,
            created_at: @message.created_at
          },
          # ADD THIS: Return updated unread counts
          unread_counts: {
            user_id => SupportMessage.where(
              sender_id: user_id,
              sender_type: "User",
              receiver_id: current_user.id,
              receiver_type: "User",
              read_at: nil
            ).count
          }
        } }
      end
    else
      respond_to do |format|
        format.html { redirect_to support_conversations_path(id: user_id), alert: "Failed to send message." }
        format.json { render json: {
          success: false,
          message: "Failed to send message.",
          errors: @message.errors.full_messages
        }, status: :unprocessable_entity }
      end
    end
  end

  private

  def require_support_access
    unless current_user.support? || current_user.admin?
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Access denied." }
        format.json { render json: { success: false, message: "Access denied." }, status: :unauthorized }
      end
    end
  end

  def send_message_notification(message)
    AdminMailer.support_reply(message.receiver, message).deliver_later
  end
end
