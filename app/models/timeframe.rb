class Timeframe < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :colorlist
  belongs_to :branch
  belongs_to :room

  TIME_SPAN = 5.freeze
  START_TIME = Time.zone.local(2017, 1, 1, 7, 0).freeze
  END_TIME = Time.zone.local(2017, 1, 1, 23, 0).freeze
end
