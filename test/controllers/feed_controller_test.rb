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

end
