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
  after_initialize :set_default_role, :if => :new_record?
  before_create :sync_ldap_attributes

  def set_default_role
    self.role ||= :participant
  end

  def in_ldap
    begin
      Devise::LDAP::Adapter.get_ldap_entry(self.username)
    rescue Net::LDAP::LdapError
      nil
    end
  end

  def ldap_get(ldap_attr)
    ldap_response = Devise::LDAP::Adapter.get_ldap_param(self.username,ldap_attr)
    return ldap_response.first unless ldap_response.nil?
  end

  def sync_ldap_attributes
    if in_ldap
      self.email = ldap_get(ENV['ldap_email'])
      self.first_name = ldap_get(ENV['ldap_first_name'])
      self.last_name = ldap_get(ENV['ldap_last_name'])
      self.employee_id = ldap_get(ENV['ldap_employee_id'])
      self.phone_number = ldap_get(ENV['ldap_phone_number'])
      self.department = ldap_get(ENV['ldap_department'])
      self.mailbox = ldap_get(ENV['ldap_mailbox'])
      self.nickname = ldap_get(ENV['ldap_nickname'])
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def enrolled?(course)
    not enrollment_for_course(course).nil?
  end

  def enrollment_for_course(course)
    results = enrollments.select { |enrollment| enrollment.course == course }
    results.first
  end

  def instructing?(course)
    results = course.sections.select { |section| section.instructor_id == id }
    results.any?
  end
end
