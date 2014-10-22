require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  test "section attributes must not be empty" do
    section = Section.new
    assert section.invalid?
    assert section.errors[:seats].any?
    assert section.errors[:course].any?
    assert section.errors[:instructor].any?
    assert section.errors[:section_number].any?
  end

  test "number of seats in a section must be positive" do
    section = Section.new(section_number: '9999',
                          instructor: users(:instructor),
                          course: courses(:canvas101))
    section.seats = -1
    assert section.invalid?
    assert_equal ["must be greater than 0"], section.errors[:seats]

    section.seats = 0
    assert section.invalid?
    assert_equal ["must be greater than 0"], section.errors[:seats]

    section.seats = 1
    assert section.valid?
  end

  test "number of seats in a section must be an integer" do
    section = Section.new(section_number: '9999',
                          instructor: users(:instructor),
                          course: courses(:canvas101))

    section.seats = 0.01
    assert section.invalid?
    assert_equal ["must be an integer"], section.errors[:seats]
  end

  test "open seats in a section is decreased by number of enrollments" do
    section = Section.create!(section_number: '9999',
                              instructor: users(:instructor),
                              course: courses(:canvas101),
                              seats: 5)
    assert_equal section.seats, section.open_seats

    section.enrollments << Enrollment.new(user: users(:george))
    assert_equal section.seats - 1, section.open_seats

    section.enrollments << Enrollment.new(user: users(:bill))
    assert_equal section.seats - 2, section.open_seats
  end

  test "section number must be unique" do
    section = Section.new(section_number: sections(:canvas101_carrier).section_number,
                          instructor: users(:instructor),
                          course: courses(:canvas101),
                          seats: 5)
    assert section.invalid?
    assert_equal ['has already been used for this course'], section.errors[:section_number]
  end
end
