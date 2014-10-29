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
      :location => "CIT Room7",
      :starts_at => Time.now,
      :section => sections(:canvas101_carrier)
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
      :location => "CIT Room7",
      :starts_at => Time.now,
      :section => sections(:canvas101_carrier)
    )

    part.duration = 0.01
    assert part.invalid?
    assert_equal ["must be an integer"], part.errors[:duration]

    part.duration = 1
    assert part.valid?
  end

  test "ends_at time is starts_at time plus duration" do
    part = Part.new(
      :location => 'CIT Room 7',
      :starts_at => Time.now,
      :duration => 90,
      :section => sections(:canvas101_carrier)
    )

    assert_equal Time.at(part.starts_at + (part.duration * 60)),
                 part.ends_at
  end
end
