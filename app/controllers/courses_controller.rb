class CoursesController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    @courses = Course.order(:title)
    respond_with(@courses)
  end

  def show
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
    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:title, :summary, :description, :duration,
                                     :instructor, :course_number)
    end
end
