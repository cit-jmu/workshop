class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  before_action :set_user

  respond_to :html, :json

  def index
    @courses = Course.order(:title)

    # split the courses into two lists, one for "current" courses
    # and one for "past" courses.  (Only admins will be able to see
    # the list of "past" courses.)
    @current_courses = []
    @past_courses = []
    @courses.each do |course|
      if course.current?
        @current_courses << course
      else
        @past_courses << course
      end
    end

    respond_with(@courses)
  end

  def show
    @available_sections = @course.current_sections.sort_by { |s| s.starts_at }
    @past_sections = @course.past_sections.sort_by { |s| s.starts_at }
    respond_with(@course)
  end

  def new
    respond_with(@course)
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    @course.save
    respond_with(@course)
  end

  def update
     @course.update(course_params)
     respond_with(@course)
  end

  def destroy
    @course.destroy
    respond_with(@course)
  end

  private
    # Never trust parameters from the scary internet
    def course_params
      params.require(:course).permit(
        :title, :summary, :description, :instructor, :course_number,
        :short_title
      )
    end

    def set_user
      @user = current_user || User.new
    end
end
