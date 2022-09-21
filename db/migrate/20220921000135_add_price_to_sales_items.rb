class AddPriceToSalesItems < ActiveRecord::Migration[6.1]
  def change
    add_column :sales_items, :price, :integer, default: 1000
  end
end
