class User < ActiveRecord::Base
  # devise modules
  devise :ldap_authenticatable, :database_authenticatable, :registerable, :rememberable, :trackable

  has_many :enrollments

  enum role: [:participant, :instructor, :admin]

  # callbacks
  after_initialize :set_default_role, :if => :new_record?
  before_create :set_attributes

  def set_default_role
    self.role ||= :participant
  end

  # method to return an attribute from ldap
  def ldap_get(ldap_attr)
    ldap_response = Devise::LDAP::Adapter.get_ldap_param(self.username,ldap_attr)
    return ldap_response.first unless ldap_response.nil?
  end

  def set_attributes
    if !ldap_get(ENV['ldap_attribute']).nil?
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

  def is_enrolled?(course)
    not enrollment_for_course(course).nil?
  end

  def enrollment_for_course(course)
    results = enrollments.select { |enrollment| enrollment.course == course }
    results.first
  end
end
