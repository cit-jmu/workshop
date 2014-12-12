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
    # There's an edge case where occassionally there may be a section part that
    # doesn't have a specific time, only a date.  The indicator for that will
    # be a start time of 12:00am.  We'll handle that case and only output the
    # date
    # TODO: There's probably a better way to do this, but this will work for now
    if start_time == '12:00am'
      "#{starts_at.strftime("%-m/%-d/%Y")}"
    else
      "#{starts_at.strftime("%-m/%-d/%Y %-l:%M%P")} - #{ends_at.strftime("%-l:%M%P")}"
    end
  end

  def start_time
    starts_at.to_s(:time_12h)
  end
end
