class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]

  def new
    redirect_to root_path and return if current_user.present?
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:notice] = "Signed in successfully."
      redirect_to root_path
    else
      flash[:error] = "Incorrect email/password."
      render :new
    end
  end

  def destroy
    if current_user
      session.clear
      flash[:notice] = "Signed out successfully."
    else
      flash[:error] = "You are not authorized to view this page."
    end
    redirect_to login_path
  end
end
