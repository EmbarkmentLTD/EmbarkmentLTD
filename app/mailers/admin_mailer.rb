# app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer
  def new_chat_message(chat_data)
    @chat_data = chat_data
    admin_emails = User.where(role: "admin").pluck(:email)

    if admin_emails.any?
      mail(
        to: admin_emails,
        subject: "💬 New Chat: #{@chat_data[:name] || 'Visitor'}",
        reply_to: @chat_data[:email]
      )
    end
  end

  # Add these new methods for support messages
  def new_support_message(support_user, message)
    @support_user = support_user
    @message = message
    @sender = message.sender

    mail(
      to: support_user.email,
      subject: "New Support Message from #{@sender.name}"
    )
  end

  def support_reply(user, message)
    @user = user
    @message = message
    @support_user = message.sender

    mail(
      to: user.email,
      subject: "Support Response from #{@support_user.name}"
    )
  end
end
