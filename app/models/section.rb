class Section < ActiveRecord::Base
  belongs_to :course

  validates :location, :starts_at, :seats, presence: true
  validates :seats, numericality: {only_integer: true, greater_than: 0}

  def open_seats
    # TODO calculate the open seats by the # of total - enrolled
    self.seats
  end

  def ends_at
    Time.at(self.starts_at + (self.course.duration * 60))
  end

  def date_and_time
    "#{self.starts_at.strftime("%-m/%-d/%Y %l:%M%P")} - #{self.ends_at.strftime("%l:%M%P")}"
  end
end
