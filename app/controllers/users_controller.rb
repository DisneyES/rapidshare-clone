class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Sign up successful."
      redirect_to root_path
    else
      flash[:error] = "Unable to sign up. Please correct the errors."
      render :new
    end
  end

  private

  def create_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
