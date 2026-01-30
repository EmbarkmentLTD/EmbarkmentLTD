class CreatePageViews < ActiveRecord::Migration[8.0]
  def change
    create_table :page_views do |t|
      t.string :path, null: false
      t.date :viewed_on, null: false
      t.integer :count, null: false, default: 0

      t.timestamps
    end

    add_index :page_views, [ :path, :viewed_on ], unique: true
    add_index :page_views, :viewed_on
  end
end
