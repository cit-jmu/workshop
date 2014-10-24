class CalendarController < ApplicationController
  def index
    @user = current_user
    @parts = Part.all
  end
end
