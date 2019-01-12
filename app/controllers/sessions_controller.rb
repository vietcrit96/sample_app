class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      if user.activated?
        remember_login user
      else
        message_not_active
      end
    else
      flash.now[:danger] = t "invalid_mail_or_pass"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def remember_login user
    log_in user
    rmb = params[:session][:remember_me]
    rmb == Settings.remember_me ? remember(user) : forget(user)
    redirect_back_or user
  end

  def message_not_active
    flash[:warning] = t "not_active_check_email"
    redirect_to root_url
  end
end
