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

  test "enroll user with blank username redirects to course section page" do
    section = sections(:canvas113_rose)
    sign_in users(:admin)
    post :enroll_user, id: section, course_id: section.course, username: ''
    assert_equal "I need a <strong>username</strong> to enroll a user, silly.", flash[:alert]
    assert_redirected_to course_section_path(section.course, section)
  end

  test "users can't be enrolled in sections they are already enrolled in" do
    section = sections(:canvas101_carrier)
    sign_in users(:admin)
    post :enroll_user, id: section, course_id: section.course, username: users(:george).username
    assert_equal "The user <strong>#{users(:george).username}</strong> is already enrolled.", flash[:notice]
    assert_redirected_to course_section_path(section.course, section)
  end
  
  test "drop user with empty user id redirects to course section page" do
    section = sections(:canvas113_rose)
    sign_in users(:admin)
    post :drop_user, id: section, course_id: section.course, user_id: ''
    assert_equal "I need a <strong>user_id</strong> to drop a user, silly.", flash[:alert]
    assert_redirected_to course_section_path(section.course, section)
  end

  test "should drop course sections" do
    sign_in users(:bill)
    assert_difference('Enrollment.count', -1) do
      delete :drop, id: @section, course_id: @section.course
    end
    assert_redirected_to course_path(@section.course)
  end

  test "admins can drop users from course sections" do
    drop_user :section => sections(:canvas101_carrier),
              :as => users(:admin)
  end

  test "instructors can drop users from their course sections" do
    drop_user :section => sections(:canvas101_carrier),
              :as => users(:professor_wiseman)
  end

  test "admins can mark users as completing a section" do
    section = sections(:canvas101_carrier)
    sign_in users(:admin)
    post :mark_completed, id: section, course_id: section.course, user_id: users(:george).id
    assert users(:george).completed? section: section
    assert_redirected_to course_section_path(section.course, section)
  end

  test "instructors can mark users as completing their sections" do
    section = sections(:canvas101_carrier)
    sign_in users(:professor_wiseman)
    post :mark_completed, id: section, course_id: section.course, user_id: users(:george).id
    assert users(:george).completed? section: section
    assert_redirected_to course_section_path(section.course, section)
  end

  test "mark complete with empty user id redirects to course section page" do
    section = sections(:canvas113_rose)
    sign_in users(:admin)
    post :mark_completed, id: section, course_id: section.course, user_id: ''
    assert_equal "I need a <strong>user_id</strong> to mark a user for completion, silly.", flash[:alert]
    assert_redirected_to course_section_path(section.course, section)
  end

  test "admins can mark users as a no show for a section" do
    section = sections(:canvas101_carrier)
    sign_in users(:admin)
    post :mark_no_show, id: section, course_id: section.course, user_id: users(:george)
    assert users(:george).no_show? section: section
    assert_redirected_to course_section_path(section.course, section)
  end

  test "instructors can mark users as a no show for a section" do
    section = sections(:canvas101_carrier)
    sign_in users(:professor_wiseman)
    post :mark_no_show, id: section, course_id: section.course, user_id: users(:george)
    assert users(:george).no_show? section: section
    assert_redirected_to course_section_path(section.course, section)
  end

  test "mark no show with empty user id redirects to course section page" do
    section = sections(:canvas113_rose)
    sign_in users(:admin)
    post :mark_no_show, id: section, course_id: section.course, user_id: ''
    assert_equal "I need a <strong>user_id</strong> to mark a user as a no-show, silly.", flash[:alert]
    assert_redirected_to course_section_path(section.course, section)
  end

  test "admins can reset a users status for a section" do
    section = sections(:canvas101_carrier)
    sign_in users(:admin)
    enrollments(:george_canvas101_carrier).completed!
    assert users(:george).completed? section: section
    
    post :reset_status, id: section, course_id: section.course, user_id: users(:george)
    assert_not users(:george).completed? section: section
  end

  test "instructors can reset a users status for their sections" do
    section = sections(:canvas101_carrier)
    sign_in users(:professor_wiseman)
    enrollments(:george_canvas101_carrier).completed!
    assert users(:george).completed? section: section
    
    post :reset_status, id: section, course_id: section.course, user_id: users(:george)
    assert_not users(:george).completed? section: section
  end

  test "resetting a users status requires a user id" do
    section = sections(:canvas113_rose)
    sign_in users(:admin)
    post :reset_status, id: section, course_id: section.course, user_id: ''
    assert_equal "I need a <strong>user_id</strong> to reset a users status, silly.", flash[:alert]
    assert_redirected_to course_section_path(section.course, section)
  end


  private
  def enroll_user(options = {})
    section = options[:section]
    user = options[:as]
    sign_in user
    assert_difference('section.enrollments.count') do
      post :enroll_user, :id => section,
                         :course_id => section.course,
                         :username => users(:george).username
    end
    assert users(:george).enrolled? :section => section
    assert_redirected_to course_section_path(section.course, section)
  end

  def drop_user(options = {})
    section = options[:section]
    user = options[:as]
    # set HTTP_REFERER since the sections#enroll action uses :back as the
    # redirect url
    request.env["HTTP_REFERER"] = course_url(section.course)
    sign_in user
    assert_difference('section.enrollments.count', -1) do
      delete :drop_user, :id => section,
                         :course_id => section.course,
                         :user_id => users(:george).id
    end
    assert_not users(:george).enrolled? :section => section
    assert_redirected_to course_section_path(section.course, section)
  end
end
