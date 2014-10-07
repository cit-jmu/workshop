require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  test "course attributes must not be empty" do
    course = Course.new
    assert course.invalid?
    assert course.errors[:title].any?
    assert course.errors[:description].any?
    assert course.errors[:instructor].any?
    assert course.errors[:duration].any?
  end
end
