class AddSalesItemIdToPayments < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :sales_item_id, :bigint
  end
end
