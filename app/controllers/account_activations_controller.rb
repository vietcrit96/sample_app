class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]

    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user_activated user
    else
      flash[:danger] = t "link_active"
      redirect_to root_url
    end
  end

  private

  def user_activated user
    user.activate
    log_in user
    flash[:success] = t "activated"
    redirect_to user
  end
end
