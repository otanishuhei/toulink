class Public::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :withdraw]
  before_action :ensure_correct_user, only: [:edit, :update, :withdraw]

  def index
    @posts = Post.published.order(created_at: :desc)

    # 検索内容と検索タイプを取得
    query = params[:query].to_s.strip
    search_type = params[:search_type]

    # 検索内容が入力されている場合のみ検索を実行
    if query.present?
      case search_type
      when "tag"
        @posts = @posts.by_tag_name(query)
      else
        @posts = @posts.search_by_query(query)
      end
    end

    # ページネーションを適用
    @posts = @posts.page(params[:page])
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.is_published = true # デフォルト設定

    if @post.save
      redirect_to post_path(@post), notice: "投稿が完了しました。"
    else
      # バリデーション失敗時はnewビューを再表示 (エラーメッセージはビューで表示)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿内容を更新しました。"
    else
      # バリデーション失敗時はeditビューを再表示 (エラーメッセージはビューで表示)
      render :edit, status: :unprocessable_entity
    end
  end

  def withdraw
    if @post.update(is_deleted: true)
      redirect_to posts_path, notice: "投稿を削除しました。"
    else
      redirect_to post_path(@post), alert: "投稿の削除に失敗しました。"
    end
  end

  private
    def set_post
      @post = Post.find_by(id: params[:id], is_deleted: false)
      unless @post
        redirect_to posts_path, alert: "指定された投稿は見つかりませんでした。"
      end
    end

    def ensure_correct_user
      unless @post.user == current_user
        redirect_to posts_path, alert: "権限がありません。"
      end
    end

    def post_params
      params.require(:post).permit(
        :title,
        :body,
        :latitude,
        :longitude,
        :post_image,
        # tags_attributes: [:name] # タグ機能の実装時に追加
      )
    end
end
