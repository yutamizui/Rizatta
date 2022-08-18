class CreateBranches < ActiveRecord::Migration[6.1]
  def change
    create_table :branches do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.references :company, foreign_key: true
      t.timestamps
    end
  end
end
