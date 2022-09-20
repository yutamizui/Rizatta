class ChangeDataNameToSalesItem < ActiveRecord::Migration[6.1]
  def change
    change_column :sales_items, :name, :string
  end
end
