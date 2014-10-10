require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  setup do
    @section = sections(:carrier_rm37)
    @update = {
      location: 'CIT Room 7',
      starts_at: '2014-10-11 12:00:00',
      seats: 6,
      course_id: @section.course_id
    }
  end

  test "should get index" do
    get :index, course_id: @section.course_id
    assert_response :success
    assert_not_nil assigns(:sections)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new, course_id: @section.course_id
    assert_response :success
  end

  test "should create section" do
    sign_in users(:admin)
    assert_difference('Section.count') do
      post :create, course_id: @section.course_id, section: @update
    end

    assert_redirected_to course_section_path(@section.course, assigns(:section))
  end

  test "should show section" do
    get :show, id: @section, course_id: @section.course_id
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @section, course_id: @section.course_id
    assert_response :success
  end

  test "should update section" do
    sign_in users(:admin)
    patch :update, id: @section, course_id: @section.course_id, section: @update
    assert_redirected_to course_section_path(@section.course, assigns(:section))
  end

  test "should destroy section" do
    sign_in users(:admin)
    assert_difference('Section.count', -1) do
      delete :destroy, id: @section, course_id: @section.course_id
    end

    assert_redirected_to course_sections_path(@section.course)
  end
end
