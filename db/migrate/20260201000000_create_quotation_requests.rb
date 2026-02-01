class CreateQuotationRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :quotation_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :contact_name, null: false
      t.string :contact_email, null: false
      t.string :contact_phone, null: false
      t.string :company
      t.string :delivery_street
      t.string :delivery_city
      t.string :delivery_state
      t.string :delivery_zip
      t.string :delivery_country
      t.text :order_details
      t.string :timeframe
      t.string :delivery_terms
      t.text :special_requirements

      t.timestamps
    end
  end
end
