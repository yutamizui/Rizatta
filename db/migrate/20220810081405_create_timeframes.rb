class CreateTimeframes < ActiveRecord::Migration[6.1]
  def change
    create_table :timeframes do |t|
      t.string :name
      t.datetime :target_date, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :start_time, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :end_time, default: -> { 'CURRENT_TIMESTAMP' }
      t.integer :capacity, default: 1, null: false
      t.integer :color, null: false
      t.integer :staff_id
      t.references :branch, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
