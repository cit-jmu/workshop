require 'test_helper'

class PartTest < ActiveSupport::TestCase
  test "part attributes must not be empty" do
    part = Part.new
    assert part.invalid?
    assert part.errors[:location].any?
    assert part.errors[:starts_at].any?
  end

  test "part ends_at time is starts_at time plus course duration" do
    part = Part.new(location: 'CIT Room 7',
                    starts_at: Time.now,
                    section: sections(:canvas101_carrier))
    assert_equal Time.at(part.starts_at + (part.section.course.duration * 60)),
                 part.ends_at
  end
end
