require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  test "enrollment user and section must not be empty" do
    enrollment = Enrollment.new
    assert enrollment.invalid?
    assert enrollment.errors[:section].any?
    assert enrollment.errors[:user].any?
  end

  test "users can only enroll in a section once" do
    enrollment = Enrollment.new(user: users(:george),
      section: sections(:canvas101_carrier))
    assert enrollment.invalid?
    assert_equal ["has already been enrolled in this section"], enrollment.errors[:user]
  end
end
