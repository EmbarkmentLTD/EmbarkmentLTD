class AddSerialNumberToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :serial_number, :string
    add_index :products, :serial_number, unique: true
  end
end
