class UsersController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    @users = User.order(:username)
    respond_with(@users)
  end

  def show
    @user ||= current_user
    @courses = Course.all # this is temporary stub data
    respond_with(@user)
  end

  def new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.save
    respond_with(@user)
  end

  def update
    @user.update(user_params)
    respond_with(@user)
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :nickname, :username,
              :email, :employee_id, :phone_number, :mailbox, :department, :role)
    end
end
