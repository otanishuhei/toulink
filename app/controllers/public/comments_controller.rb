class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      @comments = @post.comments.published.order(created_at: :desc).includes(:user)
    end

    respond_to do |format|
      format.js
    end
  end

  def withdraw
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comments = @post.comments.published.order(created_at: :desc).includes(:user)

    if @comment.user != current_user
      @error_message = "不正な操作です"
    elsif @comment.update(is_deleted: true)
      @comments = @post.comments.published.order(created_at: :desc).includes(:user)
    else
      @error_message = "コメントの削除に失敗しました"
    end

    respond_to do |format|
      format.js
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
