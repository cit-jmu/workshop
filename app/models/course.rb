class Course < ActiveRecord::Base
  validates :title, :description, :duration, :instructor, presence: true
  validates :title, uniqueness: true
  validates :duration, numericality: {greater_than: 0}
end
