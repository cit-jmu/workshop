class Course < ActiveRecord::Base
  validates_presence_of :title, :description, :duration
end