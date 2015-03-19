class SectionsController < ApplicationController
  before_action :store_custom_after_sign_in_location!, only: [:enroll, :wait_list]
  before_action :authenticate_user!, except: [:index, :show]

  load_and_authorize_resource :course
  load_and_authorize_resource :section, through: :course

  before_action :set_user
  before_action :setup_form, only: [:new, :edit]

  respond_to :html, :json

  def index
    @available_sections = @course.current_sections.sort_by { |s| s.starts_at }
    @past_sections = @course.past_sections.sort_by { |s| s.starts_at }
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
    if !@section.is_full? && @section.enroll_user!(@user)
      notice = "You are now enrolled in <strong>#{@course.title}</strong>"
      redirect_to @course, notice: notice
    else
      alert = "There was a problem enrolling you in this course"
      redirect_to @course, alert: alert
    end
  end

  def wait_list
    if @section.wait_list_user!(@user)
      notice = "You are now on the wait list for <strong>#{@course.title}</strong>"
      redirect_to @course, notice: notice
    else
      alert = "There was a problem adding you to the wait list for this course"
      redirect_to @course, alert: alert
    end
  end

  def enroll_user
    redirect_to [@course, @section] unless params[:username].present?

    user = User.find_or_create(username: params[:username])
    if user
      if @section.is_full? && @section.wait_list_user!(user)
        notice = "<strong>#{user.display_name}</strong>" \
                 " is now waiting for <strong>#{@course.title}</strong>"
        redirect_to [@course, @section], notice: notice
      elsif !@section.is_full? && @section.enroll_user!(user)
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
    if @user.enrolled?(section: @section)
      respond_with(@course, @section)
    else
      redirect_to @course,
        alert: "You must be enrolled in a course to unenroll!"
    end
  end

  def drop
    if @user.enrollment_for(section: @section, scope: :all).destroy
      notice = "You have successfully dropped <strong>#{@course.title}</strong>"
      redirect_to @course, notice: notice
    else
      redirect_to @course, alert: "Couldn't drop user from course"
    end
  end

  def drop_user
    redirect_to [@course, @section] unless params[:user_id].present?

    user = User.find(params[:user_id])
    if user
      user.enrollment_for(section: @section, scope: :all).destroy
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
      params.require(:section).permit(
        :seats,
        :section_number,
        :instructor_id,
        parts_attributes: [
          :id, :location, :starts_at, :_destroy, :duration
        ]
      )
    end

    def set_user
      @user = current_user || User.new
    end

    def setup_form
      @instructors = User.instructors
      @section.parts.build if @section.parts.empty?
    end

    # This method makes up for the fact that the Devise authenticate_user!
    # helper will only store the location to redirect to after sign in for
    # GET requests.  We want a behavior where someone who isn't signed in
    # who clicks on the [Enroll] button for a course to be directed to the
    # login page, and then redirected back to a page where they can enroll
    # in a section.  authenticate_user! doesn't do this because the enroll
    # action responds to POST requests only.  This little jobby will store
    # the location to the section#show page for a section if the user isn't
    # signed in.
    def store_custom_after_sign_in_location!
      return if user_signed_in?
      course = Course.find(params[:course_id])
      section = Section.find(params[:id])
      store_location_for :user, course_section_path(course, section)
    end
end
