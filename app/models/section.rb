class Section < ActiveRecord::Base
  has_many :enrollments
  has_many :parts
  belongs_to :course

  accepts_nested_attributes_for :parts, allow_destroy: true, reject_if: ->(attributes){
    attributes[:location].blank? and attributes[:instructor_id].blank?
  }

  validates :seats, :course, :section_number, presence: true
  validates :section_number, uniqueness: { scope: :course,
    message: "has already been used for this course"}
  validates :seats, numericality: {only_integer: true, greater_than: 0, allow_blank: true}

  def open_seats
    seats - enrollments.count
  end
end
