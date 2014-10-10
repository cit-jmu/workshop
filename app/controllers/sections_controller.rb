class SectionsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :section, :through => :course

  respond_to :html, :json

  def index
    respond_with(@course, @sections)
  end

  def show
    respond_with(@course, @section)
  end

  def new
    respond_with(@course, @section)
  end

  def edit
  end

  def create
    @section.save
    respond_with(@course, @section)
  end

  def update
    @section.update(section_params)
    respond_with(@course, @section)
  end

  def destroy
    @section.destroy
    respond_with(@course, @section)
  end

  private
    def set_section
      @section = @course.sections.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    def section_params
      params.require(:section).permit(:location, :seats, :starts_at)
    end
end
