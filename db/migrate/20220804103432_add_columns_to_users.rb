class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :phone, :string, null: false
    add_reference :users, :company, foreign_key: true
  end
end
