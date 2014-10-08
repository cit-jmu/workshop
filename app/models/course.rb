class Course < ActiveRecord::Base
  has_many :sections, dependent: :destroy

  validates :title, :description, :duration, :instructor, presence: true
  validates :title, uniqueness: true
  validates :duration, numericality: {only_integer: true, greater_than: 0}
end
