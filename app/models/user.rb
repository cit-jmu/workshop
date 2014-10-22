class User < ActiveRecord::Base
  # devise modules
  devise :ldap_authenticatable, :database_authenticatable, :rememberable, :trackable

  has_many :enrollments
  has_many :sections, foreign_key: 'instructor_id'
  has_many :courses, -> { distinct }, through: :sections

  validates :username, uniqueness: { message: "is already in use" }, presence: true
  validates :first_name, :last_name, :email, presence: true
  validates :employee_id, numericality: { only_integer: true, greater_than: 0, allow_blank: true }

  enum role: [:participant, :instructor, :admin]

  # callbacks
  after_initialize :setup_user_attributes, if: :new_record?

  def in_ldap?
    @in_ldap ||= Devise::LDAP::Adapter.get_ldap_entry(username).present?
  rescue Net::LDAP::LdapError
    false
  end

  def ldap_get(ldap_attr)
    ldap_response = Devise::LDAP::Adapter.get_ldap_param(self.username,ldap_attr)
    return ldap_response.first unless ldap_response.nil?
  end

  def sync_ldap_attributes
    return unless in_ldap?
    self.email = ldap_get(ENV['ldap_email'])
    self.first_name = ldap_get(ENV['ldap_first_name'])
    self.last_name = ldap_get(ENV['ldap_last_name'])
    self.employee_id = ldap_get(ENV['ldap_employee_id'])
    self.phone_number = ldap_get(ENV['ldap_phone_number'])
    self.department = ldap_get(ENV['ldap_department'])
    self.mailbox = ldap_get(ENV['ldap_mailbox'])
    self.nickname = ldap_get(ENV['ldap_nickname'])
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # TODO: refactor this too...
  def enrolled?(course_or_section)
    !enrollment_for(course_or_section).nil?
  end

  def enrollment_for(course_or_section)
    case
    when course_or_section.is_a?(Course)
      course = course_or_section
      results = enrollments.select { |enrollment| enrollment.course == course }
      results.first
    when course_or_section.is_a?(Section)
      section = course_or_section
      results = enrollments.select { |enrollment| enrollment.section == section }
      results.first
    else
      nil
    end
  end

  # TODO: refactor this!  I'm sure there's a cleaner way...
  def instructing?(course_or_section)
    case
    when course_or_section.is_a?(Course)
      course = course_or_section
      results = course.sections.select { |section| section.instructor_id == id }
      results.any?
    when course_or_section.is_a?(Section)
      section = course_or_section
      section.instructor_id == id
    else
      false
    end
  end

  protected
    def setup_user_attributes
      # set default role
      self.role = :participant if role.blank?

      # sync w/ LDAP
      sync_ldap_attributes if in_ldap?
    end
end
