class SectionsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :section, :through => :course

  before_action :set_user
  before_action :setup_form, :only => [:new, :edit]

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
    setup_form unless @section.save
    respond_with(@course, @section)
  end

  def update
    setup_form unless @section.update(section_params)
    respond_with(@course, @section)
  end

  def destroy
    @section.destroy
    respond_with(@course, @section)
  end

  def enroll
    if user_signed_in?
      @section.enrollments << Enrollment.new(user: @user)
      if @section.save
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

  def enroll_user
    if params[:username].present?
      if enroll_user = User.find_or_create(:username => params[:username])
        if enroll_user.enrolled?(:course => @course)
          redirect_to [@course, @section],
            :notice => "<strong>#{enroll_user.display_name}</strong> is already enrolled in <strong>#{@course.title}</strong>"
        else
          enrollment = Enrollment.new(:user => enroll_user)
          @section.enrollments << enrollment
          if @section.save
            # TODO send email
            # FIXME even better - send emails in a Section after_save hook
            redirect_to :back,
              :notice => "<strong>#{enroll_user.display_name}</strong> is now enrolled in <strong>#{@course.title}</strong>"
          else
            redirect_to [@course, @section],
              :alert => "There was a problem enrolling the user in this section"
          end
        end
      else
        redirect_to [@course, @section],
          :alert => "Could not find or create <strong>'#{params[:username]}'</strong>"
      end
    else
      redirect_to [@course, @section]
    end
  end

  def drop
    if user_signed_in?
      if @user.enrolled? :section => @section
        @user.enrollment_for(:section => @section).destroy
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

  def drop_user
  end

  private
    def section_params
      params.require(:section).permit(:seats, :section_number, :instructor_id,
                                      parts_attributes: [
                                        :id, :location, :starts_at, :_destroy,
                                        :duration
                                      ])
    end

    def set_user
      @user = current_user || User.new
    end

    def setup_form
      @instructors = User.instructors
      @section.parts.build if @section.parts.empty?
    end
end
