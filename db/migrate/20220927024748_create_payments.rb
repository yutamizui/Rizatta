class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :user
      t.integer :amount,  null: false
      t.datetime :payday, null: false

      t.timestamps
    end
  end
end
