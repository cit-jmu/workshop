require 'test_helper'

class CatalogControllerTest < ActionController::TestCase
  test "should get index for non-logged in user" do
    get :index
    assert_response :success

    assert_select '#navbar' do
      assert_select '#navbar_main a', minimum: 2
      assert_select '#user_widget a', 'Sign in'
    end

    assert_select '.curent-enrollments', false,
      "This page must not show current enrollments to a non-logged in user"
  end

  test "should get index for logged in user" do
    sign_in users(:george)
    get :index
    assert_response :success

    assert_select '#navbar' do
      assert_select '#navbar_main a', minimum: 2
      assert_select '#user_widget' do
        assert_select 'a', users(:george).display_name
        assert_select 'a', 'Sign out'
      end
    end
  end
end
