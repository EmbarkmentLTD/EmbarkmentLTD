class AddIndexesToVerificationFields < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :email_verified_at
    add_index :users, :email_verification_sent_at
    add_index :users, [ :email_verified_at, :created_at ]
  end
end
