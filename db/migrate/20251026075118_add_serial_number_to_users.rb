class AddSerialNumberToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :serial_number, :string
    add_index :users, :serial_number, unique: true
  end
end
