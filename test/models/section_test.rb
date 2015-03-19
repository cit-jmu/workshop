require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  test "attributes must not be empty" do
    section = Section.new
    assert section.invalid?
    assert section.errors[:seats].any?
    assert section.errors[:course].any?
    assert section.errors[:instructor].any?
    assert section.errors[:section_number].any?
  end

  test "number of seats must be positive" do
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

  test "number of seats must be an integer" do
    section = Section.new(section_number: '9999',
                          instructor: users(:instructor),
                          course: courses(:canvas101))

    section.seats = 0.01
    assert section.invalid?
    assert_equal ["must be an integer"], section.errors[:seats]
  end

  test "open seats is decreased by number of enrollments" do
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

  test "duration is the sum of its parts" do
    section = Section.create!(
      section_number: 'CIT999',
      instructor: users(:instructor),
      seats: 6,
      course: courses(:canvas101),
      parts_attributes: [{
        location: "CIT Room7",
        starts_at: Time.current,
        duration: 45
      },{
        location: "CIT Room7",
        starts_at: Time.current.advance(:weeks => 1),
        duration: 45
      }]
    )
    assert_equal 90, section.duration
  end

  test "section isn't current if doesn't have any parts" do
    section = sections(:canvas101_carrier)
    assert_not section.current?
  end

  test "section isn't current if it doesn't have any current parts" do
    section = sections(:canvas101_carrier)
    # create a past part in the database
    Part.create!(
      location: 'Room7',
      starts_at: Time.current.advance(days: -1),
      duration: 30,
      section: section
    )
    assert_not section.current?
  end

  test "section is current if it contains at least one current part" do
    section = sections(:canvas101_carrier)
    # create a past part in the database
    Part.create!(
      location: 'Room7',
      starts_at: Time.current.advance(days: -1),
      duration: 30,
      section: section
    )
    # create a future part in the database
    Part.create!(
      location: 'Room7',
      starts_at: Time.current.advance(days: 1),
      duration: 30,
      section: section
    )
    assert section.current?
  end
end
