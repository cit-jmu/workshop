class User < ActiveRecord::Base
  enum role: [:user, :instructor, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # devise modules
  devise :ldap_authenticatable, :database_authenticatable, :registerable, :rememberable, :trackable

  # method to return an attribute from ldap
  def ldap_get(ldap_attr)
    ldap_response = Devise::LDAP::Adapter.get_ldap_param(self.username,ldap_attr)
    return ldap_response.first unless ldap_response.nil?
  end

  def set_attributes
    self.email = ldap_get(ENV['ldap_email'])
    self.first_name = ldap_get(ENV['ldap_first_name'])
    self.last_name = ldap_get(ENV['ldap_last_name'])
    self.employee_id = ldap_get(ENV['ldap_employee_id'])
    self.phone_number = ldap_get(ENV['ldap_phone_number'])
    self.department = ldap_get(ENV['ldap_department'])
    self.mailbox = ldap_get(ENV['ldap_mailbox'])
    self.nickname = ldap_get(ENV['ldap_nickname'])
  end

  before_save :set_attributes

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
