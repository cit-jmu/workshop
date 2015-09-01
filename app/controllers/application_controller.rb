class ApplicationController < ActionController::Base
  # Devise rescue
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # CanCan rescue
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Add a HSTS (HTTPS Strict Transport Security) header
  before_filter :add_strict_transport_security_header

  def add_strict_transport_security_header
    max_age = 60 * 60 * 24 * 365 # one year

    # use an X- header in development to show it's getting set, but not
    # enabling it (since we're not running https in development)
    header_name = Rails.env.development?  ? 'X-Strict-Transport-Security'
                                          : 'Strict-Transport-Security'

    response.header[header_name] = "max-age=#{max_age}; includeSubDomains";
  end
end
