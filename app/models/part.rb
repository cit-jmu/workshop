class Part < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar

  belongs_to :section

  validates :location, :starts_at, :duration, presence: true
  validates :duration, numericality: {only_integer: true, greater_than: 0}

  def ends_at
    Time.zone.at(starts_at + (duration * 60))
  end

  def date_and_time
    "#{starts_at.strftime("%-m/%-d/%Y %l:%M%P")} - #{ends_at.strftime("%l:%M%P")}"
  end

  def start_time
    starts_at.to_s(:time_12h)
  end
end
