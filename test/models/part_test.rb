require 'test_helper'

class PartTest < ActiveSupport::TestCase
  test "attributes must not be empty" do
    part = Part.new
    assert part.invalid?
    assert part.errors[:location].any?
    assert part.errors[:starts_at].any?
  end

  test "duration must be greater than zero" do
    part = Part.new(
      location: "CIT Room7",
      starts_at: Time.current,
      section: sections(:canvas101_carrier)
    )

    part.duration = -1
    assert part.invalid?
    assert_equal ["must be greater than 0"], part.errors[:duration]

    part.duration = 0
    assert part.invalid?
    assert_equal ["must be greater than 0"], part.errors[:duration]

    part.duration = 1
    assert part.valid?
  end

  test "duration must be an integer" do
    part = Part.new(
      location: "CIT Room7",
      starts_at: Time.current,
      section: sections(:canvas101_carrier)
    )

    part.duration = 0.01
    assert part.invalid?
    assert_equal ["must be an integer"], part.errors[:duration]

    part.duration = 1
    assert part.valid?
  end

  test "ends_at time is starts_at time plus duration" do
    part = Part.new(
      location: 'CIT Room 7',
      starts_at: Time.current,
      duration: 90,
      section: sections(:canvas101_carrier)
    )

    assert_equal Time.zone.at(part.starts_at + (part.duration * 60)),
                 part.ends_at
  end

  test "when start time is midnight only display date" do
    part = Part.new(
      location: 'CIT Room 7',
      starts_at: Time.current.at_beginning_of_day,
      duration: 90,
      section: sections(:canvas101_carrier)
    )

    assert_equal "#{part.starts_at.strftime("%-m/%-d/%Y")}", part.date_and_time
  end

  test "parts starting in the past are not current" do
    part = Part.new(
      location: 'CIT Room 7',
      starts_at: Time.current.advance(days: -21),
      duration: 60,
      section: sections(:canvas101_carrier)
    )
    assert_not part.current?
  end

  test "parts starting on the current day are current" do
    part = Part.new(
      location: 'CIT Room 7',
      starts_at: Time.current,
      duration: 60,
      section: sections(:canvas101_carrier)
    )
    assert part.current?
  end

  test "parts starting in the future are not considered current" do
    part = Part.new(
      location: 'CIT Room 7',
      starts_at: Time.current.advance(days: 21),
      duration: 60,
      section: sections(:canvas101_carrier)
    )
    assert part.current?
  end

  test "current scope only returns current parts" do
    # create a part in the past
    past = Part.create!(
      location: 'Room7',
      starts_at: Time.current.advance(days: -2),
      duration: 60,
      section: sections(:canvas101_carrier)
    )
    # create a part in the present
    present = Part.create!(
      location: 'Room7',
      starts_at: Time.current,
      duration: 60,
      section: sections(:canvas101_carrier)
    )
    # create a part in the future
    future = Part.create!(
      location: 'Room7',
      starts_at: Time.current.advance(days: 2),
      duration: 60,
      section: sections(:canvas101_carrier)
    )

    parts = Part.current
    assert_equal 2, parts.length
    assert_not_includes parts, past,
      "'current' scope shouldn't include past parts"
    assert_includes parts, present,
      "'current' scope should inclue present parts"
    assert_includes parts, future,
      "'current' scope should inclue future parts"
  end
end
