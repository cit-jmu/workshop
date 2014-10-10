class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  has_one :course, through: :section

  validates :user, :section, presence: true
end
