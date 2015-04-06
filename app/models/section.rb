class Section < ActiveRecord::Base
  has_many :enrollments, dependent: :destroy
  has_many :parts, dependent: :destroy
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
    when user.enrolled?(:section => self, scope: :all) then false
    when user.enrolled?(:course => course, scope: :all) then false
    when user.instructing?(:section => self) then false
    else true
    end
  end

  def enroll_user!(user)
    # don't enroll if they are already enrolled in the course
    # or if the section is full
    return nil if user.enrolled?(course: course) || is_full?
    self.enrollments << Enrollment.new(user: user)
    save
  end

  def wait_list_user!(user)
    # don't wait list if they are already waiting in the course
    return nil if user.enrolled?(course: course, scope: :waiting)
    self.enrollments << Enrollment.new(user: user, waiting: true)
    save
  end

  def is_full?
    open_seats <= 0
  end

  def open_seats
    seats - enrollments.active.count
  end

  def duration
    parts.inject(0) { |duration, part| duration + part.duration }
  end

  def starts_at
    return nil unless parts.any?
    parts.order(:starts_at).first.starts_at
  end

  def current?
    current_parts.any?
  end

  def current_parts
    @current_parts ||= parts.select { |p| p.current? }
  end

  def past_parts
    @past_parts ||= parts.reject { |p| p.current? }
  end

  def roster
    enrollments.active.sort { |a,b| a.user.last_name <=> b.user.last_name }
  end
end
