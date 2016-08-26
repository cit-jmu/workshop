class FeedController < ApplicationController
  respond_to :json, :atom, :rss, :csv

  def index
    @courses = Course.order(:title).select { |c| c.current? }
    respond_with @courses
  end

  def upcoming
    items = params[:items] || 20
    @parts = Part.where('starts_at >= ?', Time.current.at_beginning_of_day).order(starts_at: :asc).limit(items)
    respond_with @parts
  end
end
