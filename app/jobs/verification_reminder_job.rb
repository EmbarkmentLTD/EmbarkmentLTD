class VerificationReminderJob < ApplicationJob
  queue_as :default

  def perform
    # Find users who need reminders
    User.where(email_verified_at: nil)
        .where("created_at < ?", 24.hours.ago)
        .where("last_verification_reminder_at IS NULL OR last_verification_reminder_at < ?", 24.hours.ago)
        .find_each do |user|
      user.send_verification_reminder
    end
  end
end
