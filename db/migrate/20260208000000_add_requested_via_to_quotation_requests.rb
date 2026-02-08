class AddRequestedViaToQuotationRequests < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:quotation_requests, :requested_via)
      add_column :quotation_requests, :requested_via, :string, null: false, default: "email"
    end
    add_index :quotation_requests, :requested_via unless index_exists?(:quotation_requests, :requested_via)
  end
end