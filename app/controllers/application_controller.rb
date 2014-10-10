class ApplicationController < ActionController::Base
  # Devise rescue
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # CanCan rescue
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: "Access denied."
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    user_profile_path
  end
end
