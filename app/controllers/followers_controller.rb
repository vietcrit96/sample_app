class FollowersController < ApplicationController
  before_action :load_user
  before_action :logged_in_user

  def show
    @title = t "followers"
    @users = @user.followers.page params[:page]
    render "users/show_follow"
  end
end
