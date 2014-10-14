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

  def enroll
    if current_user
      @section.enrollments << Enrollment.new(user: current_user)
      if @section.save
        UserMailer.enroll_email(current_user, @section).deliver
        redirect_to @course, notice: "You are now enrolled in <strong>#{@course.title}</strong>"
      else
        redirect_to @course, alert: "There was a problem enrolling you in this course"
      end
    else
      # TODO setup a redirect to login, then resume enrollment
      redirect_to @course, alert: "You must be logged in to enroll in courses"
    end
  end

  def drop
    if current_user
      if current_user.is_enrolled? @course
        current_user.enrollment_for_course(@course).destroy
        # redirect to :back since you can drop courses from multiple pages
        # (e.g. course#show and users#profile both have the drop course feature)
        redirect_to :back, notice: "You have successfully dropped <strong>#{@course.title}</strong>"
      else
        redirect_to @course, alert: "You can't drop a course unless you are enrolled in it"
      end
    else
      # TODO setup a redirect to login, then resume enrollment
      redirect_to @course, alert: "You must be logged in to drop a course"
    end
  end

  def roster
  end

  private
    def set_section
      @section = @course.sections.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    def section_params
      params.require(:section).permit(:location, :seats, :starts_at, :section_number, :instructor_id)
    end
end
