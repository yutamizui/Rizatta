class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.integer :user_id
      t.integer :reservation_id
      t.datetime :expired_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.boolean :status, default: true, null: false

      t.timestamps
    end
  end
end
