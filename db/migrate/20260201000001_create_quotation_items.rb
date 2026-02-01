class CreateQuotationItems < ActiveRecord::Migration[8.0]
  def change
    create_table :quotation_items do |t|
      t.references :quotation_request, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end

    add_index :quotation_items, [ :quotation_request_id, :product_id ], unique: true, name: "index_quotation_items_on_request_and_product"
  end
end
