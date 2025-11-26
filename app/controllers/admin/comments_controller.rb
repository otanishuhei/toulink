class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_comment, only: [:update]

  def index
    @comments = Comment.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def update
    if @comment.toggle(:is_active).save
      flash[:notice] = "{#@comment.name} の公開ステータスを更新しました"
      redirect_to admin_comments_path(page: params[:page])
    else
      flash.now[:alert] = "コメントステータスの更新に失敗しました"
      @comments = Comment.all.order(created_at: :desc).page(params[:page]).per(10)
      render :index
    end
  end

  private
  def set_comment
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      flash[:alert] = "指定されたコメントは見つかりませんでした"
      redirect_to admin_comments_path and return
    end
  end
end
