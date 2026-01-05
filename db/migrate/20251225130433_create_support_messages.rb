class CreateSupportMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :support_messages do |t|
      t.references :sender, polymorphic: true, null: false
      t.references :receiver, polymorphic: true, null: false
      t.text :message
      t.datetime :read_at

      t.timestamps
    end
  end
end
