class Timeframe < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :colorlist
  belongs_to :branch
  belongs_to :room
end
