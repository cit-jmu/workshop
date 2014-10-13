require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @course = courses(:canvas101)
    @update = {
      title: "Teaching Monkeys to Sing",
      course_number: 'CITTEST',
      description: "Singing monkeys are the awesome!",
      duration: 30,
      instructor: "The Man with the Yellow Hat"
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:courses)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should create course" do
    sign_in users(:admin)
    assert_difference('Course.count') do
      post :create, course: @update
    end

    assert_redirected_to course_path(assigns(:course))
  end

  test "should show course" do
    get :show, id: @course
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @course
    assert_response :success
  end

  test "should update course" do
    sign_in users(:admin)
    patch :update, id: @course, course: @update
    assert_redirected_to course_path(assigns(:course))
  end

  test "should destroy course" do
    sign_in users(:admin)
    assert_difference('Course.count', -1) do
      delete :destroy, id: @course
    end

    assert_redirected_to courses_path
  end
end
