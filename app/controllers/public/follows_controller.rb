class Public::FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    current_user.follow(@user)
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(@user)
    redirect_to request.referer
  end

  def followings
    @users = @user.followings.active.page(params[:page]).per(10)
  end

  def followers
    @users = @user.followers.active.page(params[:page]).per(10)
  end

  private
    def set_user
      @user = User.find(params[:user_id] || params[:id])
    end
end
