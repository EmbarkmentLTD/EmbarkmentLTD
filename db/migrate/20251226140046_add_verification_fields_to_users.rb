class AddVerificationFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email_verification_code, :string
    add_column :users, :email_verification_sent_at, :datetime
    add_column :users, :email_verified_at, :datetime
    add_column :users, :unverified_email, :string
    add_column :users, :last_verification_reminder_at, :datetime
    add_column :users, :verification_attempts, :integer
  end
end
