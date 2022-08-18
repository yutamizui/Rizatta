class AddColumnsToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :name, :string, null: false
    add_column :companies, :address, :string, null: false
    add_column :companies, :phone, :string, null: false
    add_column :companies, :secret_code, :string, null: false
  end
end
