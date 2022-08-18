class AddBranchIdToStaffs < ActiveRecord::Migration[6.1]
  def change
    add_reference :staffs, :branch, foreign_key: true
  end
end
