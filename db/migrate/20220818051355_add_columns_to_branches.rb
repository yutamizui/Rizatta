class AddColumnsToBranches < ActiveRecord::Migration[6.1]
  def change
    add_column :branches, :makable_reservation_hour_span, :integer, default: 24, null: false
    add_column :branches, :cancelable_reservation_hour_span, :integer, default: 24, null: false
    add_column :branches, :calendar_start_time, :datetime, default: '2000-01-01 10:00:00 '
    add_column :branches, :calendar_end_time, :datetime, default: '2000-01-01 20:00:00 '
  end
end
