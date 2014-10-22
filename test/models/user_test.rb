require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user knows if they are enrolled in a course" do
    user = users(:george)
    assert user.enrolled? courses(:canvas101)
  end

  test "user provides enrollment for course if enrolled" do
    user = users(:george)
    enrollment = user.enrollment_for(courses(:canvas101))
    assert_equal enrollments(:george_canvas101_carrier), enrollment
  end

  test "user knows if they are instucting a course" do
    user = users(:professor_wiseman)
    assert user.instructing?(courses(:canvas101))

    user = users(:bill)
    assert !user.instructing?(courses(:canvas113))
  end
end
