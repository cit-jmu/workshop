class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  has_one :course, :through => :section

  scope :active, -> { where(waiting: false) }
  scope :waiting, -> { where(waiting: true) }

  validates :user, :section, :presence => true
  validates :user, uniqueness: { :scope => :section,
    :message =>  "has already been enrolled in this section"}

  before_create do |enrollment|
    enrollment.ical_event_uid = SecureRandom.uuid
  end

  after_create do |enrollment|
    if enrollment.active?
      enrollment.section.parts.each do |part|
        UserMailer.enroll_email(enrollment, part).deliver
      end
    end
  end

  after_destroy do |enrollment|
    if enrollment.active?
      enrollment.section.parts.each do |part|
        UserMailer.unenroll_email(enrollment, part).deliver
      end
    end
  end

  def completed!
    self.completed_at = Time.current unless completed?
    save
  end

  def completed?
    completed_at.present?
  end

  def active!
    self.waiting = false
    save
  end

  def active?
    !waiting
  end

  def waiting!
    self.waiting = true
    save
  end

  def waiting?
    waiting
  end
end
