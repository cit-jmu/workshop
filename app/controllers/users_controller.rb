class UsersController < ApplicationController
  def profile
    @courses = Course.all
  end
end
