class Section < ActiveRecord::Base
  has_many :enrollments
  has_many :parts
  belongs_to :course
  belongs_to :instructor, class_name: 'User'

  accepts_nested_attributes_for :parts, allow_destroy: true,
    reject_if: ->(attributes) {
      attributes[:location].blank? && attributes[:starts_at].blank?
    }

  validates :seats, :course, :section_number, :instructor, presence: true
  validates :section_number, uniqueness: { scope: :course,
    message: "has already been used for this course"}
  validates :seats, numericality: {only_integer: true, greater_than: 0, allow_blank: true}

  def enrollable_for?(user)
    case
    when user.enrolled?(:section => self) then false
    when user.enrolled?(:course => course) then false
    when user.instructing?(:section => self) then false
    else true
    end
  end

  def enroll_user!(user)
    # don't enroll if they are already enrolled in the course
    return nil if user.enrolled?(course: course)
    self.enrollments << Enrollment.new(user: user)
    self.save
  end

  def open_seats
    seats - enrollments.count
  end

  def duration
    # section duration is the sum of all its parts
    parts.inject(0) { |duration, part| duration + part.duration }
  end

  def start_date
    parts.order(:starts_at).first.starts_at
  end
end
