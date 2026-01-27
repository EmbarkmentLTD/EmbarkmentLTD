class AddSupplierResponseToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :supplier_response, :text
    add_column :reviews, :supplier_response_at, :datetime
  end
end
