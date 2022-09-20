class AddTicketPriceToCompanies < ActiveRecord::Migration[6.1]
  def change
    add_column :companies, :ticket_price, :integer, default: 1000
  end
end
