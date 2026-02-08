class AddRequestedViaToQuotationRequests < ActiveRecord::Migration[8.0]
  def change
    add_column :quotation_requests, :requested_via, :string, null: false, default: "email"
    add_index :quotation_requests, :requested_via
  end
end