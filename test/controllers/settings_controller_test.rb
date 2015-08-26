require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  setup do
    @setting = settings(:test_setting)
  end

  # index
  test "visitors can't get index" do
    get :index
    assert_response :redirect
  end

  test "participants can't get index" do
    sign_in users(:participant)
    get :index
    assert_response :redirect
  end

  test "instructors can't get index" do
    sign_in users(:instructor)
    get :index
    assert_response :redirect
  end

  test "admins can get index" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:settings)
  end

  # new
  test "visitors can't get new" do
    get :new
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "participants can't get new" do
    sign_in users(:participant)
    get :new
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "instructors can't get new" do
    sign_in users(:instructor)
    get :new
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "admin can get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  # create
  test "visitors can't create settings" do
    post :create, setting: { name: "a_name", value: "a_value"}
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "participants can't create settings" do
    sign_in users(:participant)
    post :create, setting: { name: "a_name", value: "a_value"}
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "instructors can't create settings" do
    sign_in users(:instructor)
    post :create, setting: { name: "a_name", value: "a_value"}
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "admins can create settings" do
    sign_in users(:admin)
    assert_difference('Setting.count') do
      post :create, setting: { name: "a_name", value: "a_value"}
    end

    assert_redirected_to setting_path(assigns(:setting))
  end

  # show
  test "don't show setting to visitors" do
    get :show, id: @setting
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "don't show setting to participants" do
    sign_in users(:participant)
    get :show, id: @setting
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "don't show setting to instructors" do
    sign_in users(:instructor)
    get :show, id: @setting
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "should show setting to admin" do
    sign_in users(:admin)
    get :show, id: @setting
    assert_response :success
  end

  # edit
  test "visitors can't get edit" do
    get :edit, id: @setting
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "participants can't get edit" do
    sign_in users(:participant)
    get :edit, id: @setting
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "instructors can't get edit" do
    sign_in users(:instructor)
    get :edit, id: @setting
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "admins can get edit" do
    sign_in users(:admin)
    get :edit, id: @setting
    assert_response :success
  end

  # update
  test "visitors can't update setting" do
    patch :update, id: @setting, setting: { name: @setting.name, value: "new_val" }
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "participants can't update setting" do
    sign_in users(:participant)
    patch :update, id: @setting, setting: { name: @setting.name, value: "new_val" }
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "instructors can't update setting" do
    sign_in users(:instructor)
    patch :update, id: @setting, setting: { name: @setting.name, value: "new_val" }
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "admins can update setting" do
    sign_in users(:admin)
    patch :update, id: @setting, setting: { name: @setting.name, value: "new_val" }
    assert_redirected_to setting_path(assigns(:setting))
  end

  # destroy
  test "visitors can't destroy setting" do
    delete :destroy, id: @setting
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "participants can't destroy setting" do
    sign_in users(:participant)
    delete :destroy, id: @setting
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "instructors can't destroy setting" do
    sign_in users(:instructor)
    delete :destroy, id: @setting
    assert_response :redirect
    assert_equal "You are not authorized to access this page.", flash[:alert]
  end

  test "admin can destroy setting" do
    sign_in users(:admin)
    assert_difference('Setting.count', -1) do
      delete :destroy, id: @setting
    end

    assert_redirected_to settings_path
  end
end
