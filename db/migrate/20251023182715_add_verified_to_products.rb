class AddVerifiedToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :verified, :boolean
  end
end
