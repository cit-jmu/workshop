class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    @user ||= current_user
    @courses = Course.all # this is temporary stub data
  end

  private
    def set_user
      @user = User.find(params[:id]) if params[:id]
    end
end
