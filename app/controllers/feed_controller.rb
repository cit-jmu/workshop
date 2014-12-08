class FeedController < ApplicationController
  respond_to :json, :atom, :rss, :csv
  def index
    @courses = Course.order(:title)
    respond_with @courses
  end

  def upcoming
    @parts = Part.where('starts_at >= ?', Time.current.at_beginning_of_day).order(starts_at: :asc).limit(5)
    respond_with @parts
  end
end
