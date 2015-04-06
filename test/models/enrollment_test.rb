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

  test "enrollments can be marked as completed" do
    enrollment = enrollments(:george_canvas101_carrier)
    enrollment.completed!
    assert enrollment.completed?
  end

  test "enrollments can be marked as a no-show" do
    enrollment = enrollments(:george_canvas101_carrier)
    enrollment.no_show!
    assert enrollment.no_show?
    assert_not enrollment.completed?
  end

  test "enrollment status can be reset" do
    enrollment = enrollments(:george_canvas101_carrier)

    # mark enrollment as no-show
    enrollment.no_show!
    assert enrollment.no_show?
    # now reset it and make sure it got reset
    enrollment.reset_status!
    assert_not enrollment.no_show?

    # mark enrollment as completed
    enrollment.completed!
    assert enrollment.completed?
    # and reset it
    enrollment.reset_status!
    assert_not enrollment.completed?
  end
end
