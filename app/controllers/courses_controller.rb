class CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :set_user

  respond_to :html, :json

  def index
    @courses = Course.order(:title)
    respond_with(@courses)
  end

  def cit_feed
    @courses = Course.order(:title)
    # using respond_to to only expose the formats we need
    respond_to do |format|
      format.json { render } # cit_feed.json.jbuilder
      format.atom { render } # cit_feed.atom.builder
      format.rss  { render } # cit_feed.rss.builder
      format.csv  { render } # cit_feed.csv.ruby
    end
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
