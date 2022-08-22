class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.references :user, foreign_key: true
      t.references :timeframe, foreign_key: true

      t.timestamps
    end
  end
end
