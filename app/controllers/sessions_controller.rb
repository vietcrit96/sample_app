class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      remember_login user
    else
      flash.now[:danger] = t "invalid_mail_or_pass"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def remember_login user
    log_in user
    rmb = params[:session][:remember_me]
    rmb == Settings.remember_me ? remember(user) : forget(user)
    redirect_back_or user
  end
end
