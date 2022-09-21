class AddEffectiveDateToSalesItems < ActiveRecord::Migration[6.1]
  def change
    add_column :sales_items, :effective_date, :integer, default: 30
  end
end
