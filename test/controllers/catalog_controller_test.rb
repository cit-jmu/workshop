require 'test_helper'

class CatalogControllerTest < ActionController::TestCase
  test "should get index for non-logged in user" do
    get :index
    assert_response :success

    assert_select '#navbar' do
      assert_select '#navbar_main a', minimum: 2
      assert_select '#user_widget a', 'Login'
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
        assert_select '.user-label', users(:george).full_name
        assert_select '.user-menu a', 'Profile'
        assert_select '.user-menu a', 'Logout'
      end
    end

    assert_select '.current-enrollments .table tbody' do
      assert_select '.enrollment', 1
      assert_select '.enrollment' do
        enrollment = enrollments(:george_canvas101_carrier)
        assert_select '.course-title', enrollment.course.title
        assert_select '.section-datetime', enrollment.section.date_and_time
        assert_select '.section-location', enrollment.section.location
        assert_select '.actions a', 'Drop course'
      end
    end
  end
end
