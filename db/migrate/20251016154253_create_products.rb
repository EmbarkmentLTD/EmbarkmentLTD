class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :category
      t.decimal :price
      t.integer :stock_quantity
      t.string :unit
      t.string :location
      t.boolean :is_organic
      t.boolean :featured
      t.date :harvest_date
      t.date :expiry_date
      t.decimal :average_rating
      t.integer :reviews_count

      t.timestamps
    end
  end
end
