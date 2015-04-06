require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user knows if they are enrolled in a course" do
    # add an active part to the course
    course = courses(:canvas101)
    Part.create!(
      section: course.sections.first,
      starts_at: Time.current,
      duration: 20,
      location: 'rm7'
    )
    user = users(:george)
    assert user.enrolled? course: course
  end

  test "user provides enrollment for course if enrolled" do
    user = users(:george)
    enrollment = user.enrollment_for :course => courses(:canvas101)
    assert_equal enrollments(:george_canvas101_carrier), enrollment
  end

  test "user knows if they are instucting a course" do
    user = users(:professor_wiseman)
    assert user.instructing?(:course => courses(:canvas101))

    user = users(:bill)
    assert !user.instructing?(:course => courses(:canvas113))
  end

  test "has scope for instructors" do
    instructors = User.instructors
    assert_includes instructors, users(:instructor),
      "Instructor was not found in instructors collection"
    assert_includes instructors, users(:admin),
      "Admin was not found in instructors collection"
    assert_not_includes instructors, users(:participant),
      "Participant was found in instructors collection"

  end

  test "can find or create a user" do
    # find an existing user
    user = User.find_or_create(:username => users(:george).username)
    assert_equal user, users(:george)

    # create a new user
    user = User.find_or_create(
      :username => 'jumpy',
      :first_name => 'Jumpy',
      :last_name => 'Squirrel',
      :email => 'jumpy.squirrel@example.org'
    )
    assert user
    assert user.id.present?
  end

  test "user is not enrolled if they were a no show" do
    course = courses(:canvas101)
    Part.create!(
      section: course.sections.first,
      starts_at: Time.current,
      duration: 25,
      location: 'rm7'
    )
    user = users(:george)
    enrollment = user.enrollment_for course: course
    enrollment.no_show!
    assert_not user.enrolled? course: course
    assert_not_includes user.current_enrollments, enrollment
  end
end
