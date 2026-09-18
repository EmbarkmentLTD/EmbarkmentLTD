require "test_helper"

class VerificationReminderJobTest < ActiveJob::TestCase
  include ActiveSupport::Testing::TimeHelpers

  test "sends reminders only to eligible unverified users" do
    travel_to Time.zone.local(2026, 9, 19, 12, 0, 0) do
      eligible_user = User.create!(
        name: "Eligible User",
        email: "eligible.#{SecureRandom.hex(4)}@gmail.com",
        password: "Password123!",
        password_confirmation: "Password123!",
        role: "buyer",
        location: "Lagos"
      )
      eligible_user.update_columns(
        created_at: 2.days.ago,
        last_verification_reminder_at: nil,
        email_verified_at: nil
      )

      ineligible_user = User.create!(
        name: "Recent User",
        email: "recent.#{SecureRandom.hex(4)}@gmail.com",
        password: "Password123!",
        password_confirmation: "Password123!",
        role: "buyer",
        location: "Lagos"
      )
      ineligible_user.update_columns(
        created_at: 1.hour.ago,
        last_verification_reminder_at: nil,
        email_verified_at: nil
      )

      perform_enqueued_jobs do
        VerificationReminderJob.perform_now
      end

      eligible_user.reload
      ineligible_user.reload

      assert_not_nil eligible_user.last_verification_reminder_at
      assert_nil ineligible_user.last_verification_reminder_at
      assert_equal 1, ActionMailer::Base.deliveries.count
      assert_equal [ eligible_user.email ], ActionMailer::Base.deliveries.last.to
      assert_equal "Complete Your Email Verification", ActionMailer::Base.deliveries.last.subject
    end
  end

  test "runs on the default queue" do
    assert_equal "default", VerificationReminderJob.new.queue_name
  end
end
