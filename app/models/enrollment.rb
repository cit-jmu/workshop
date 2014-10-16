class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  has_one :course, through: :section

  validates :user, :section, presence: true
  validates :user, uniqueness: { scope: :section,
    message: "has already been enrolled in this section"}

  before_create do |enrollment|
    enrollment.ical_event_uid = SecureRandom.uuid
  end
end