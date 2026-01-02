class AddDefaultValuesToProducts < ActiveRecord::Migration[8.0]
  def change
    change_column_default :products, :average_rating, 0.0
    change_column_default :products, :reviews_count, 0
    change_column_default :products, :stock_quantity, 0
    change_column_default :products, :is_organic, false
    change_column_default :products, :featured, false
    
    # Update existing records with nil values
    Product.where(average_rating: nil).update_all(average_rating: 0.0)
    Product.where(reviews_count: nil).update_all(reviews_count: 0)
    Product.where(stock_quantity: nil).update_all(stock_quantity: 0)
  end
end
