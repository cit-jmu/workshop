class CalendarController < ApplicationController
  def index
    @user = current_user
    @parts = Part.all

    @start_date ||= (params[:start_date] || Time.current).to_date
    @parts_this_month = @parts.select do |part|
      part.starts_at.between?(@start_date.beginning_of_month,
                              @start_date.end_of_month)
    end.sort_by(&:starts_at)
  end
end
