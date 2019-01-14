class FollowingController < ApplicationController
  before_action :load_user
  before_action :logged_in_user

  def show
    @title = t "following"
    @users = @user.following.page params[:page]
    render "users/show_follow"
  end
end
