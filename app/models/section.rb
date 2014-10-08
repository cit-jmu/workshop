class Section < ActiveRecord::Base
  belongs_to :course

  validates :location, :starts_at, :seats, presence: true
  validates :seats, numericality: {only_integer: true, greater_than: 0}
end
