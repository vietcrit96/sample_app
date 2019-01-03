class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "sample_app"
      redirect_to @user
    else
      flash[:danger] = t "signup_err"
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "notice_show"
    redirect_to signup_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
