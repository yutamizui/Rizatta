class Timeframe < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :colorlist
  belongs_to :branch
  belongs_to :room
  has_many :reservations, dependent: :destroy

  TIME_SPAN = 5.freeze
  START_TIME = Time.zone.local(2017, 1, 1, 7, 0).freeze
  END_TIME = Time.zone.local(2017, 1, 1, 23, 0).freeze

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :capacity, presence: true, numericality: true
  validates :color, presence: true
  validate :timeframe_duplicate
  validate :timeframe_span_check
  validate :timeframe_start_time_check
  validate :timeframe_end_time_check

  #バリデーション
  def date
    self.target_date
  end

  def timeframe_duplicate
    if self.branch.present? && Timeframe.where(target_date: target_date).where("room_id = ?", room_id)
      .where("start_time < ?", end_time).where("end_time > ?", start_time).where.not(id: self.id).where(branch_id: self.branch_id).present?
      errors.add(:start_time, ": ご入力いただいた時間帯にすでにレッスンが存在します。")
    end
  end

  def timeframe_span_check
    if start_time && start_time.strftime('%H:%M') >= end_time.strftime('%H:%M')
        errors.add(:start_time, :timeframe_start_time_should_be_smaller_than_end_time)
    end
  end

  def timeframe_start_time_check
    if start_time && start_time.strftime('%H:%M') < self.branch.calendar_start_time.strftime('%H:%M')
      errors.add(:start_time, :timeframe_start_time_should_be_within_calendar_start_time)
    end
  end

  def timeframe_end_time_check
    if end_time && end_time.strftime('%H:%M') > self.branch.calendar_end_time.strftime('%H:%M')
      errors.add(:end_time, :timeframe_end_time_should_be_within_calendar_end_time)
    end
  end


  #判定用
  def self.timeframe_duplicate?(timeframe)
    Timeframe.where("start_time <=?", timeframe.target_date.strftime("%Y-%m-%d") + " " + timeframe.end_time.strftime("%H:%M:%S"))
    .where("end_time >= ?", timeframe.target_date.strftime("%Y-%m-%d") + " " + timeframe.start_time.strftime("%H:%M:%S"))
    .where("room_id = ?", timeframe.room_id).present?
  end
end
