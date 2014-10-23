class Part < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar

  belongs_to :section


  validates :location, :starts_at, presence: true

  def ends_at
    Time.at(starts_at + (section.course.duration * 60))
  end

  def date_and_time
    "#{starts_at.strftime("%-m/%-d/%Y %l:%M%P")} - #{ends_at.strftime("%l:%M%P")}"
  end

  def start_time
    starts_at.to_s(:time_12h)
  end
end
