class Section < ActiveRecord::Base
  has_many :enrollments
  belongs_to :course

  validates :location, :starts_at, :seats, :course, :section_number,
            presence: true
  validates :section_number, uniqueness: { scope: :course,
    message: "has already been used for this course"}
  validates :seats, numericality: {only_integer: true, greater_than: 0, allow_blank: true}

  def open_seats
    # TODO calculate the open seats by the # of total - enrolled
    seats - enrollments.count
  end

  def ends_at
    Time.at(starts_at + (course.duration * 60))
  end

  def date_and_time
    "#{starts_at.strftime("%-m/%-d/%Y %l:%M%P")} - #{ends_at.strftime("%l:%M%P")}"
  end
end
