require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "guest should get profile" do
    get :show
    assert_response :success
  end
  test "participant should get profile" do
    sign_in users(:participant)
    get :show
    assert_response :success
  end
    test "instructor should get profile" do
    sign_in users(:instructor)
    get :show
    assert_response :success
  end
    test "admin should get profile" do
    sign_in users(:admin)
    get :show
    assert_response :success
  end
end
