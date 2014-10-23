class CalendarController < ApplicationController
  def index
    @parts = Part.all
  end
end
