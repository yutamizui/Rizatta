class AddRequiredTicketNumberToTimeframes < ActiveRecord::Migration[6.1]
  def change
    add_column :timeframes, :required_ticket_number, :integer, default: 1, null: false
  end
end
