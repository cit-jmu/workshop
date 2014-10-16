require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  def setup
    @course = courses(:canvas101)
  end

  test "admins can manage courses" do
    ability = Ability.new(users(:admin))
    assert ability.can?(:create, @course)
    assert ability.can?(:read, @course)
    assert ability.can?(:update, @course)
    assert ability.can?(:destroy, @course)
  end

  test "instructors can read courses" do
    ability = Ability.new(users(:professor_wiseman))
    assert ability.can?(:read, @course)
  end

  test "instructors can update courses they teach" do
    ability = Ability.new(users(:professor_wiseman))
    assert ability.can?(:update, @course)
  end

  test "instructors cannot create courses" do
    ability = Ability.new(users(:professor_wiseman))
    # test :create on the Course class rather than the instance, since when
    # creating a Course you don't have an instance yet
    assert ability.cannot?(:create, Course)
  end

  test "instructors cannot destroy courses" do
    ability = Ability.new(users(:professor_wiseman))
    assert ability.cannot?(:destroy, @course)
  end

  test "participants can read courses" do
    ability = Ability.new(users(:bill))
    assert ability.can?(:read, @course)
  end

  test "participants cannot create courses" do
    ability = Ability.new(users(:bill))
    assert ability.cannot?(:create, Course)
  end

  test "participants cannot update courses" do
    ability = Ability.new(users(:bill))
    assert ability.cannot?(:update, @ourse)
  end

  test "participants cannot destroy courses" do
    ability = Ability.new(users(:bill))
    assert ability.cannot?(:destroy, @course)
  end

end
