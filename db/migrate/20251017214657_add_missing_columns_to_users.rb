class AddMissingColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, if_not_exists: true
    add_column :users, :location, :string, if_not_exists: true
    add_column :users, :role, :string, default: 'buyer', if_not_exists: true

    add_column :products, :average_rating, :decimal,
      precision: 3, scale: 2, default: 0.0, if_not_exists: true

    add_column :products, :reviews_count, :integer,
      default: 0, if_not_exists: true
  end
end
