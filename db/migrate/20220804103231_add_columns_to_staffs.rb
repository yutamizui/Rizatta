class AddColumnsToStaffs < ActiveRecord::Migration[6.1]
  def change
    add_column :staffs, :name, :string, null: false
    add_column :staffs, :phone, :string, null: false
    add_column :staffs, :status, :integer, null: false
    add_reference :staffs, :company, foreign_key: true
  end
end
