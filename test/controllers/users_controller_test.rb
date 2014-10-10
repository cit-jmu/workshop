require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "guest should get profile" do
    get :profile
    assert_response :success
  end
  test "user should get profile" do
    sign_in users(:user)
    get :profile
    assert_response :success
  end
    test "instructor should get profile" do
    sign_in users(:instructor)
    get :profile
    assert_response :success
  end
    test "admin should get profile" do
    sign_in users(:admin)
    get :profile
    assert_response :success
  end
end
