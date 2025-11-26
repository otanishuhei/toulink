class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_post, only: [:show, :update]

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def update
    if @post.toggle(:is_published).save
      flash[:notice] = "{#@post.name} の公開ステータスを更新しました"
      redirect_to admin_post_path(@post)
    else
      flash.now[:alert] = "投稿ステータスの更新に失敗しました"
      render :show
    end
  end

  private
  def set_post
    @post = Post.find_by(id: params[:id])
    unless @post
      flash[:alert] = "指定された投稿は見つかりませんでした"
      redirect_to admin_posts_path and return
    end
  end
end
