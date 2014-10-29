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

  # scope to get all instructors
  scope :instructors, -> {
    where('role >= ?', User.roles[:instructor]).order(:last_name)
  }

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
    [first_name, last_name].join(' ')
  end

  def display_name
    [display_first, last_name].join(' ')
  end

  def display_first
    if nickname.present?
      nickname
    else
      first_name
    end
  end

  def enrolled?(options = {})
    enrollment_for(options).present?
  end

  def enrollment_for(options = {})
    if options[:course]
      enrollments.select do |enrollment|
        enrollment.course == options[:course]
      end.first
    elsif options[:section]
      enrollments.select do |enrollment|
        enrollment.section == options[:section]
      end.first
    else
      nil
    end
  end

  def instructing?(options = {})
    if options[:course]
      options[:course].sections.select do |section|
        section.instructor_id == id
      end.any?
    elsif options[:section]
      options[:section].instructor_id == id
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
