class SectionsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :section, :through => :course

  before_action :set_user

  respond_to :html, :json

  def index
    respond_with(@course, @sections)
  end

  def show
    respond_with(@course, @section)
  end

  def new
    @section.parts.build
    respond_with(@course, @section)
  end

  def edit
    @section.parts.build
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
      enrollment = Enrollment.new(user: current_user)
      @section.enrollments << enrollment
      if @section.save
        @section.parts.each { |part| UserMailer.enroll_email(enrollment, part).deliver }
        # redirect to :back since you can enroll in courses from multiple pages
        # makes it cleaner to stay on the page you were on
        redirect_to :back, notice: "You are now enrolled in <strong>#{@course.title}</strong>"
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
      if current_user.enrolled? :course => @course
        enrollment = current_user.enrollment_for :course => @course
        enrollment.destroy
        @section.parts.each { |part| UserMailer.unenroll_email(enrollment, part).deliver }
        # redirect to :back since you can drop courses from multiple pages
        # makes it cleaner to stay on the page you were on
        redirect_to :back, notice: "You have successfully dropped <strong>#{@course.title}</strong>"
      else
        redirect_to @course, alert: "You can't drop a course unless you are enrolled in it"
      end
    else
      # TODO setup a redirect to login, then resume enrollment
      redirect_to @course, alert: "You must be logged in to drop a course"
    end
  end

  private
    def section_params
      params.require(:section).permit(:seats, :section_number, :instructor_id,
                                      parts_attributes: [:id, :location, :starts_at, :_destroy])
    end

    def set_user
      @user = current_user || User.new
    end
end
