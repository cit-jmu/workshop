require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  test "should get enrollments" do
    get :enrollments
    assert_response :success
  end

end
