require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  setup do
    @section = sections(:canvas101_carrier)
    @update = {
      section_number: '9999',
      location: 'CIT Room 7',
      starts_at: '2014-10-11 12:00:00',
      instructor_id: users(:professor_wiseman).id,
      seats: 6
    }
  end

  test "should get index" do
    get :index, course_id: @section.course
    assert_response :success
    assert_not_nil assigns(:sections)
  end

  test "should get index as a logged in user" do
    sign_in users(:participant)
    get :index, course_id: @section.course
    assert_response :success
    assert_not_nil assigns(:sections)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new, course_id: @section.course
    assert_response :success
  end

  test "should create section" do
    sign_in users(:admin)
    assert_difference('Section.count') do
      post :create, course_id: @section.course, section: @update
    end

    assert_redirected_to course_section_path(@section.course, assigns(:section))
  end

  test "should show section" do
    get :show, id: @section, course_id: @section.course
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @section, course_id: @section.course
    assert_response :success
  end

  test "should update section" do
    sign_in users(:admin)
    patch :update, id: @section, course_id: @section.course, section: @update
    assert_redirected_to course_section_path(@section.course, assigns(:section))
  end

  test "should destroy section" do
    sign_in users(:admin)
    assert_difference('Section.count', -1) do
      delete :destroy, id: @section, course_id: @section.course
    end

    assert_redirected_to course_sections_path(@section.course)
  end

  test "should enroll in course sections" do
    section = sections(:canvas113_rose)
    # set HTTP_REFERER since the sections#enroll action uses :back as the
    # redirect url
    request.env["HTTP_REFERER"] = course_url(section.course)
    sign_in users(:george)
    assert_difference('section.enrollments.count') do
      post :enroll, id: section, course_id: section.course
    end
    assert_redirected_to course_path(section.course)
  end

  test "admins can enroll users in course sections" do
    enroll_user :section => sections(:canvas113_rose),
                :as => users(:admin)
  end

  test "instructors can enroll users in their course sections" do
    enroll_user :section => sections(:canvas113_rose),
                :as => users(:instructor)
  end

  test "should drop course sections" do
    # set HTTP_REFERER since the sections#drop action uses :back as the
    # redirect url
    request.env["HTTP_REFERER"] = course_url(@section.course)
    sign_in users(:bill)
    assert_difference('Enrollment.count', -1) do
      delete :drop, id: @section, course_id: @section.course
    end
    assert_redirected_to course_path(@section.course)
  end

  private
  def enroll_user(options = {})
    section = options[:section]
    user = options[:as]
    # set HTTP_REFERER since the sections#enroll action uses :back as the
    # redirect url
    request.env["HTTP_REFERER"] = course_url(section.course)
    sign_in user
    assert_difference('section.enrollments.count') do
      post :enroll_user, :id => section,
                         :course_id => section.course,
                         :username => users(:george).username
    end
    assert users(:george).enrolled? :section => section
    assert_redirected_to course_path(section.course)
  end
end
