class Admin::HomesController < ApplicationController
  before_action :authenticate_admin!
  def top
    @users_count = User.count
    @posts_count = Post.count
    @comments_count = Comment.count
    @communities_count = Community.count
    @events_count = Event.count
  end
end
