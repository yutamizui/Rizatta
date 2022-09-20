class SalesItem < ApplicationRecord
  validates :name, presence: true
  validates :number_of_ticket, presence: true
  validates :branch_id, presence: true
end
