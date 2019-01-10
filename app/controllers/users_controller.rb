class UsersController < ApplicationController
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.activated.page(params[:page]).per Settings.split_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      send_email_active @user
    else
      flash[:danger] = t "signup_err"
      render :new
    end
  end

  def show
    redirect_to(root_url) && return unless @user
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "update_success"
      redirect_to @user
    else
      flash[:danger] = t "edit_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_del"
      redirect_to users_url
    else
      flash[:danger] = t "user_del_fail"
      render :users
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return false if logged_in?
    store_location
    flash[:danger] = t "please_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "notice_show"
    redirect_to signup_path
  end

  def send_email_active user
    user.send_activation_email
    flash[:info] = t "please_check_email"
    redirect_to root_url
  end
end
