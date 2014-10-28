require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:participant)
    @update = {
      username: "monkeydave",
      first_name: "David",
      last_name: "Themonkey",
      email: "dave@themonkey.com",
    }
  end

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

  test "should get index" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should create user" do
    sign_in users(:admin)
    assert_difference('User.count') do
      post :create, user: @update
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user profile" do
    sign_in users(:admin)
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    sign_in users(:admin)
    patch :update, id: @user, user: @update
    assert_redirected_to edit_user_path(assigns(:user))
  end

  test "should destroy user" do
    sign_in users(:admin)
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
