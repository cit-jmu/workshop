class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :rememberable, :trackable

  def ldap_set(ldap_attr)
    ldap_response = Devise::LDAP::Adapter.get_ldap_param(self.username,ldap_attr)
    return ldap_response.first unless ldap_response.nil?
  end

  def set_attributes
    self.email = ldap_set(ENV['ldap_email'])
    self.first_name = ldap_set(ENV['ldap_first_name'])
    self.last_name = ldap_set(ENV['ldap_last_name'])
    self.employee_id = ldap_set(ENV['ldap_employee_id'])
    self.phone_number = ldap_set(ENV['ldap_phone_number'])
    self.department = ldap_set(ENV['ldap_department'])
    self.mailbox = ldap_set(ENV['ldap_mailbox'])
    self.nickname = ldap_set(ENV['ldap_nickname'])
  end

  before_save :set_attributes

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
