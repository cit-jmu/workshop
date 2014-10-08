class SectionsController < ApplicationController
  before_action :set_course
  before_action :set_section, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @sections = @course.sections
    respond_with(@course, @sections)
  end

  def show
    respond_with(@course, @section)
  end

  def new
    @section = Section.new
    respond_with(@course, @section)
  end

  def edit
  end

  def create
    @section = Section.new(section_params)
    @section.course_id = @course.id
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
