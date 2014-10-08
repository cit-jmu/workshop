require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  test "section attributes must not be empty" do
    section = Section.new
    assert section.invalid?
    assert section.errors[:location].any?
    assert section.errors[:starts_at].any?
    assert section.errors[:seats].any?
    assert section.errors[:course].any?
  end

  test "number of seats in a section must be positive" do
    section = Section.new(location: 'CIT Room 7',
                          starts_at: Time.now,
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
    section = Section.new(location: 'CIT Room 7',
                          starts_at: Time.now,
                          course: courses(:canvas101))

    section.seats = 0.01
    assert section.invalid?
    assert_equal ["must be an integer"], section.errors[:seats]
  end

  test "section ends_at time is starts_at time plus course duration" do
    section = Section.new(location: 'CIT Room 7',
                          starts_at: Time.now,
                          course: courses(:canvas101),
                          seats: 6)
    assert_equal Time.at(section.starts_at + (section.course.duration * 60)),
                 section.ends_at
  end
end
