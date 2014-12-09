class SectionsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :section, through: :course

  before_action :set_user
  before_action :setup_form, only: [:new, :edit]

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
      if @section.enroll_user!(@user)
        notice = "You are now enrolled in <strong>#{@course.title}</strong>"
        redirect_to [@course, @section], notice: notice
      else
        alert = "There was a problem enrolling you in this course"
        redirect_to @course, alert: alert
      end
    else
      # TODO setup a redirect to login, then resume enrollment
      redirect_to @course, alert: "You must be logged in to enroll in courses"
    end
  end

  def enroll_user
    redirect_to [@course, @section] unless params[:username].present?

    user = User.find_or_create(username: params[:username])
    if user
      if @section.enroll_user!(user)
        notice = "<strong>#{user.display_name}</strong>" \
                 " is now enrolled in <strong>#{@course.title}</strong>"
        redirect_to [@course, @section], notice: notice
      else
        alert = "There was a problem enrolling" \
                " <strong>#{user.display_name}</strong>" \
                " in <strong>#{@course.title}</strong>"
        redirect_to [@course, @section], notice: alert
      end
    else
      alert = "Could not find or create <strong>'#{params[:username]}'</strong>"
      redirect_to [@course, @section], alert: alert
    end
  end

  def confirm_unenroll
    if user_signed_in?
      if @user.enrolled?(section: @section)
        respond_with(@course, @section)
      else
        redirect_to @course,
          alert: "You must be enrolled in a course to unenroll!"
      end
    else
      # TODO setup a redirect to login, then resume enrollment
      redirect_to @course, alert: "You must be logged in to drop a course"
    end
  end

  def drop
    if user_signed_in?
      if @user.enrollment_for(section: @section).destroy
        notice = "You have successfully dropped <strong>#{@course.title}</strong>"
        redirect_to [@course, @section], notice: notice
      else
        redirect_to @course, alert: "Couldn't drop user from course"
      end
    else
      # TODO setup a redirect to login, then resume enrollment
      redirect_to @course, alert: "You must be logged in to drop a course"
    end
  end

  def drop_user
    redirect_to [@course, @section] unless params[:user_id].present?

    user = User.find(params[:user_id])
    if user
      user.enrollment_for(section: @section).destroy
      notice = "<strong>#{user.display_name}</strong>" \
               " has been dropped from <strong>#{@course.title}</strong>"
      redirect_to [@course, @section], notice: notice
    else
      alert = "Couldn't find that enrollment for this section"
      redirect_to [@course, @section], alert: alert
    end
  end

  def mark_completed
    redirect_to [@course, @section] unless params[:user_id].present?

    user = User.find(params[:user_id])
    if user
      user.enrollment_for(section: @section).completed!
      notice = "<strong>#{user.display_name}</strong>" \
               " has completed <strong>#{@course.title}</strong>"
      redirect_to [@course, @section], notice: notice
    else
      alert = "Couldn't find user"
      redirect_to [@course, @section], alert: alert
    end
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
