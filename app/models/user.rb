class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  def set_attributes
    self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,ENV['ldap_email']).first
    self.first_name = Devise::LDAP::Adapter.get_ldap_param(self.username,ENV['ldap_first_name']).first
    self.last_name = Devise::LDAP::Adapter.get_ldap_param(self.username,ENV['ldap_last_name']).first
    self.employee_id = Devise::LDAP::Adapter.get_ldap_param(self.username,ENV['ldap_employee_id']).first
  end

  before_save :set_attributes

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
