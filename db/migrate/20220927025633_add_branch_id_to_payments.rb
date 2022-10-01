class AddBranchIdToPayments < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :branch_id, :bigint
  end
end
