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
    @user ||= current_user
  end

  def create
    @user = User.new(user_params)
    @user.save
    respond_with(@user)
  end

  def update
    attributes = user_params
    # protect the :role attribute, only set it if @user can assign
    # permissions
    attributes[:role] = params[:role] if can? :assign_permissions, @user

    # use respond_to here instead of respond_with so we can customize the
    # redirect url to be the edit page after a successful update
    respond_to do |format|
      if @user.update(attributes)
        # redirect to '/profile' if current_user, otherwise use the restful
        # route '/users/:id/edit'
        redirect_url = if @user == current_user
          profile_url
        else
          edit_user_url(@user)
        end
        format.html { redirect_to redirect_url,
                        :notice => 'Profile was successfully updated.' }
        format.json { render :show, :status => :ok, :location => @user }
      else
        format.html { render :edit }
        format.json { render :json => @user.errors,
                             :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_with(@user)
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :nickname, :username,
              :email, :employee_id, :phone_number, :mailbox, :department,
              :computer_preference)
    end
end
