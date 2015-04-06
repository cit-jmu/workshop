require 'test_helper'

class FeedControllerTest < ActionController::TestCase
  test "should get index" do
    [:json, :atom, :rss, :csv].each do |format|
      get :index, format: format
      assert_response :success
    end
  end

  test "should get upcoming" do
    [:json, :atom, :rss, :csv].each do |format|
      get :upcoming, format: format
      assert_response :success
    end
  end

  test "should return empty if no current courses" do
    course = courses(:canvas101)
    # add a section in the past
    Part.create!(
      location: 'rm7',
      starts_at: Time.current.advance(days: -21),
      duration: 30,
      section: course.sections.first
    )

    [:json, :atom, :rss, :csv].each do |format|
      get :index, format: format
      assert_response :success
      assert_empty assigns(:courses)
    end
  end

  test "should only return current courses" do
    canvas101 = courses(:canvas101)
    prof_wiseman = users(:professor_wiseman)
    # sections in the past and the future
    section_number = 1
    [-7, 14].each do |days_to_advance|
      Section.create!(
        course: canvas101,
        instructor: prof_wiseman,
        section_number: "900#{section_number}",
        seats: 5,
        parts: [Part.new(
          location: 'rm7',
          starts_at: Time.current.advance(days: days_to_advance),
          duration: 25
        )]
      )
      section_number += 1
    end

    [:json, :atom, :rss, :csv].each do |format|
      get :index, format: format
      assert_response :success
      # there are 2 sections, but only one is current
      assert_equal 1, assigns(:courses).length
    end
  end

end
