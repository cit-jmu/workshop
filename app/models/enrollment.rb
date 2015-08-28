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

  after_create :notify_enroll, if: :active?
  after_destroy :notify_unenroll, if: :active?
  after_destroy :check_wait_list, unless: :section_full?

  def completed!
    self.completed_at = Time.current unless completed?
    self.no_show = false
    save
    send_evaluation
  end

  def no_show!
    self.no_show = true
    self.completed_at = nil
    save
  end

  def no_show?
    no_show
  end

  def reset_status!
    self.no_show = false
    self.completed_at = nil
    save
  end

  def section_full?
    section.is_full?
  end

  def completed?
    completed_at.present?
  end

  def activate!
    self.waiting = false
    save
  end

  def active?
    !waiting
  end

  def wait!
    self.waiting = true
    save
  end

  def waiting?
    waiting
  end

  def promote
    activate!
    notify_enroll
  end

  def send_reminder
    UserMailer.reminder_email(self).deliver_now
  end

  def send_evaluation
    UserMailer.evaluation_email(self).deliver_now
  end

  protected

    def notify_enroll
      UserMailer.alert_email(self).deliver_now if section.alert_email?

      section.parts.each do |part|
        UserMailer.enroll_email(self, part).deliver_now
      end
    end

    def notify_unenroll
      section.parts.each do |part|
        UserMailer.unenroll_email(self, part).deliver_now
      end
    end

    def check_wait_list
      enrollment = section.enrollments.waiting.order(:created_at).first
      enrollment.promote if enrollment
    end
end
