class StatsController < ApplicationController
  def enrollments
    @courses = Course.order(:title)
  end
end
