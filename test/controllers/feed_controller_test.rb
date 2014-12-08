require 'test_helper'

class FeedControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get upcoming" do
    get :upcoming
    assert_response :success
  end

end
