class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = current_user.likes.new(post_id: @post.id)
    @like.save
  end

  def destroy
    @like = current_user.likes.find_by(post_id: @post.id)
    @like&.destroy # nilをチェックしたあとでいいね削除
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end
end
