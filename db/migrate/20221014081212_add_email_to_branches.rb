class AddEmailToBranches < ActiveRecord::Migration[6.1]
  def change
    add_column :branches, :email, :string, default: "", null: false
  end
end
