class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params

    if @micropost.save
      flash[:success] = t ".post_created"
      redirect_to root_url
    else
      flash[:danger] = t ".fail_post_create"
      @feed_items = current_user.feed.page(params[:page])
                                .per Settings.split_page
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".post_del"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = t ".post_del_fail"
      redirect_to root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end
end
