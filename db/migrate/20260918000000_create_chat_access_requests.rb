class CreateChatAccessRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_access_requests do |t|
      t.references :requester, polymorphic: true, null: false
      t.references :target, polymorphic: true, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :chat_access_requests,
      [ :requester_type, :requester_id, :target_type, :target_id ],
      unique: true,
      name: "index_chat_access_requests_on_requester_target_unique"
  end
end
