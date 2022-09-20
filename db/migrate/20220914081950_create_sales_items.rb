class CreateSalesItems < ActiveRecord::Migration[6.1]
  def change
    create_table :sales_items do |t|
      t.integer :name, null: false
      t.integer :number_of_ticket, default: 1, null: false
      t.references :branch, foreign_key: true

      t.timestamps
    end
  end
end
