# app/controllers/support_dashboard_controller.rb
class SupportDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_support_access

  def index
    @users = if current_user.admin? || current_user.support?
               User.where.not(id: current_user.id)
    else
               User.none
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
        pending_requests = ChatAccessRequest.pending.includes(:requester, :target).map do |request|
          {
            id: request.id,
            requester: {
              id: request.requester_id,
              name: request.requester.respond_to?(:name) ? request.requester.name : "Unknown"
            },
            target: {
              id: request.target_id,
              name: request.target.respond_to?(:name) ? request.target.name : "Unknown"
            },
            created_at: request.created_at
          }
        end

        render json: {
          users: @users.as_json(only: [ :id, :name, :email, :role ]),
          unread_counts: @unread_counts,
          current_user_unread: current_user.unread_support_messages_count,
          pending_chat_requests: pending_requests,
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
    unless current_user.can_chat_with?(@other_user)
      redirect_to support_dashboard_path, alert: "You are not allowed to chat with this user yet."
      return
    end

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
    user_id = params[:user_id] || params.dig(:support_message, :user_id)

    unless user_id.present?
      respond_to do |format|
        format.html { redirect_back fallback_location: support_dashboard_path, alert: "Please select a user." }
        format.json { render json: { success: false, message: "Please select a user." }, status: :unprocessable_entity }
      end
      return
    end

    @other_user = User.find(user_id)
    unless current_user.can_chat_with?(@other_user)
      respond_to do |format|
        format.html { redirect_to support_dashboard_path, alert: "You are not allowed to chat with this user yet." }
        format.json { render json: { success: false, message: "You are not allowed to chat with this user yet." }, status: :forbidden }
      end
      return
    end

    message_text = params[:message] || params.dig(:support_message, :message)

    @message = SupportMessage.new(
      message: message_text,
      sender: current_user,
      receiver: @other_user
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

  def approve_chat_access_request
    request = ChatAccessRequest.pending.find(params[:id])
    request.update!(status: "approved")

    respond_to do |format|
      format.html { redirect_back fallback_location: support_dashboard_path, notice: "Chat access request approved." }
      format.json { render json: { success: true, message: "Chat access request approved.", request_id: request.id } }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_back fallback_location: support_dashboard_path, alert: "Request not found or already processed." }
      format.json { render json: { success: false, message: "Request not found or already processed." }, status: :not_found }
    end
  end

  private

  def require_support_access
    unless current_user.admin? || (current_user.support? && current_user.email_verified?)
      respond_to do |format|
        format.html { redirect_to verification_path, alert: "Please verify your support account to access the dashboard." }
        format.json { render json: { success: false, message: "Please verify your support account to access the dashboard." }, status: :forbidden }
      end
      return
    end

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
