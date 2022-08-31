class Branch < ApplicationRecord
  belongs_to :company
  has_many :staffs, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :timeframes, dependent: :destroy
  has_many :rooms
end
