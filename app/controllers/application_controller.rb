class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  before_action :authenticate

  private

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    session.clear
    flash[:error] = "You are not logged in."
    redirect_to login_path
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate
      redirect_to '/login' unless current_user
  end
end
