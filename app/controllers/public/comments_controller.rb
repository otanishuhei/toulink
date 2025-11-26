class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user_id = current_user.id

    @comments = @post.comments.published.order(create_at: :desc).includes(:user)

    if @comment.save
    else
    end
  end

  def withdraw
    @comment = Comment.find(params[:id])

    unless @comment.user == current_user
      redirect_to post_path(@comment.post), alert: "不正な操作です"
      return
    end

    if @comment.update(is_deleted: true)
      flash[:notice] = "コメントを削除しました"
    else
      flash[:alert] = "コメントの削除に失敗しました"
    end
    redirect_to post_path(@comment.post)
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
