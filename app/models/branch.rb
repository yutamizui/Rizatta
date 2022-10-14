class Branch < ApplicationRecord
  belongs_to :company
  has_many :staffs, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :timeframes, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :sales_items, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :address, presence: true
end
