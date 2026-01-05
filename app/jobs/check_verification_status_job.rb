# app/jobs/check_verification_status_job.rb
class CheckVerificationStatusJob < ApplicationJob
  queue_as :default
  
  def perform(user_id)
    user = User.find(user_id)
    
    # If user still hasn't verified after 3 days, send a final reminder
    if !user.email_verified? && user.created_at < 3.days.ago
      UserMailer.final_verification_reminder(user).deliver_later
    end
  end
end