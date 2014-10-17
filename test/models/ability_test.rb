require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  def setup
    @course = courses(:canvas101)
    @section = sections(:canvas101_carrier)
  end

  # Courses

  test "anyone can see courses" do
    [:admin, :instructor, :participant].each do |user|
      ability = Ability.new(users(user))
      assert ability.can?(:read, @course)
    end
  end

  test "only admins can manage courses" do
    ability = Ability.new(users(:admin))
    assert ability.can?(:create, Course)
    assert ability.can?(:update, @course)
    assert ability.can?(:destroy, @course)

    [:participant, :instructor].each do |user|
      ability = Ability.new(users(user))
      assert ability.cannot?(:create, Course)
      assert ability.cannot?(:update, @course)
      assert ability.cannot?(:destroy, @course)
    end
  end

  test "instructors can only update courses they teach" do
    ability = Ability.new(users(:professor_wiseman))
    assert ability.can?(:update, @course)
    assert ability.cannot?(:update, courses(:canvas113))
  end

  # Sections

  test "anyone can see sections" do
    [:admin, :instructor, :participant].each do |user|
      ability = Ability.new(users(user))
      assert ability.can?(:read, @section)
    end
  end

  test "anyone can enroll in sections" do
    [:admin, :instructor, :participant].each do |user|
      ability = Ability.new(users(user))
      assert ability.can?(:enroll, @section)
    end
  end

  test "anyone can drop in sections" do
    [:admin, :instructor, :participant].each do |user|
      ability = Ability.new(users(user))
      assert ability.can?(:drop, @section)
    end
  end

  test "only admins can manage sections" do
    ability = Ability.new(users(:admin))
    assert ability.can?(:create, Section)
    assert ability.can?(:update, @section)
    assert ability.can?(:destroy, @section)

    [:instructor, :participant].each do |user|
      ability = Ability.new(users(user))
      assert ability.cannot?(:create, Section)
      assert ability.cannot?(:update, @section)
      assert ability.cannot?(:destroy, @section)
    end
  end

  test "admins can see enrollments for any section" do
    ability = Ability.new(users(:admin))
    assert ability.can?(:view_enrollments, @section)
  end

  test "instructors can only see the enrollments for sections they teach" do
    ability = Ability.new(users(:professor_wiseman))
    assert ability.can?(:view_enrollments, @section)
    assert ability.cannot?(:view_enrollments, sections(:canvas113_rose))
  end

end
