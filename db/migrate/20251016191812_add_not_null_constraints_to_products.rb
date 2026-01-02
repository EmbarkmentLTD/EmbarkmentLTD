class AddNotNullConstraintsToProducts < ActiveRecord::Migration[8.0]
  def change
    change_column_null :products, :average_rating, false, 0.0
    change_column_null :products, :reviews_count, false, 0
    change_column_null :products, :stock_quantity, false, 0
  end
end
