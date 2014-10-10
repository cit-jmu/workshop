require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user knows if they are enrolled in a course" do
    user = users(:george)
    assert user.is_enrolled? courses(:canvas101)
  end

  test "user provides enrollment for course if enrolled" do
    user = users(:george)
    enrollment = user.enrollment_for_course courses(:canvas101)
    assert_equal enrollments(:george_canvas101_carrier), enrollment
  end
end
