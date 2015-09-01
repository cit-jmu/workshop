class User < ActiveRecord::Base
  # devise modules
  devise :ldap_authenticatable, :database_authenticatable, :rememberable, :trackable

  has_many :enrollments, dependent: :destroy
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
  before_validation :setup_user_attributes, if: :new_record?
  before_create :ensure_random_password, if: :in_ldap?

  def self.find_or_create(options)
    User.where(username: options[:username]).first || User.create!(options)
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def in_ldap?
    @in_ldap ||= Devise::LDAP::Adapter.get_ldap_entry(username).present?
  rescue Net::LDAP::Error
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
    enrollment = enrollment_for(options)
    enrollment.present? && !(enrollment.completed? || enrollment.no_show?)
  end

  def waiting?(options = {})
    options[:scope] = :waiting
    enrollment = enrollment_for(options)
    enrollment.present?
  end

  def enrollment_for(options = {})
    # set default scope to active
    options = options.reverse_merge(scope: :active)
    enrollments_scope = enrollments.send(options[:scope])
    if options[:course]
      found = enrollments_scope.select do |enrollment|
        enrollment.course == options[:course]
      end
    elsif options[:section]
      found = enrollments_scope.select do |enrollment|
        enrollment.section == options[:section]
      end
    else
      found = Enrollment.none
    end
    found.first
  end

  def instructing?(options = {})
    if options[:course]
      options[:course].sections.select { |section| section.instructor == self }.any?
    elsif options[:section]
      options[:section].instructor == self
    else
      false
    end
  end

  def completed?(options = {})
    enrollment = enrollment_for(options)
    enrollment.present? && enrollment.completed?
  end
  
  def no_show?(options = {})
    enrollment = enrollment_for(options)
    enrollment.present? && enrollment.no_show?
  end

  def current_enrollments
    enrollments.select do |enrollment|
      enrollment.section.current? &&
        !(enrollment.completed? || enrollment.no_show?)
    end
  end

  def completed_enrollments
    enrollments.select { |enrollment| enrollment.completed? }
  end

  protected
    def setup_user_attributes
      # set default role
      self.role = :participant if role.blank?

      # sync w/ LDAP
      sync_ldap_attributes if in_ldap?
    end

    def ensure_random_password
      self.password = SecureRandom.base64(12)
      self.password_confirmation = self.password
    end
end
