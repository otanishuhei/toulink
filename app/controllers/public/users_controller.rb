class Public::UsersController < ApplicationController
  # ログイン中のユーザーのみアクセス可能
  before_action :authenticate_user!
  # 自分の情報に関するアクションのみ、退会済ユーザーのアクセスを許可しない
  before_action :ensure_active_user, except: [:show, :index]
  # 自分のレコードのみ編集・更新・退会ができるように設定
  before_action :ensure_correct_user, only: [:edit, :update, :unsubscribe, :withdraw]

  # GET /users
  def index
    @users = User.active.page(params[:page]).per(20)
  end

  # GET /users/:id
  def show
    @user = User.active.find(params[:id])
    @posts = @user.posts.published.order(created_at: :desc).limit(10)
  end

  # GET /mypage
  def mypage
    @user = current_user
    @posts = @user.posts.order(created_at: :desc).limit(10)
  end

  # GET /mypage/edit
  def edit
    # @userはensure_correct_userで設定済み
  end

  # PATCH/PUT /mypage
  def update
    # @userはensure_correct_userで設定済み
    if @user.update(user_params)
      redirect_to mypage_path, notice: "登録情報を更新しました。"
    else
      render :edit
    end
  end

  # GET /mypage/unsubscribe
  def unsubscribe
    # @userはensure_correct_userで設定済み
  end

  # PATCH /mypage/withdraw
  def withdraw
    # @userはensure_correct_userで設定済み
    @user.update(is_active: false) # 論理削除
    reset_session # 強制ログアウト
    redirect_to root_path, notice: "退会処理を実行しました。ご利用いただきありがとうございました。"
  end

  # GET /mypage/likes
  def likes
    @user = current_user
    @liked_posts = @user.liked_posts.published.page(params[:page]).per(10)
  end

  # GET /mypage/comments
  def comments
    @user = current_user
    @comments = @user.comments.published.order(created_at: :desc).page(params[:page]).per(10)
  end

  # GET /mypage/communities
  def communities
    @user = current_user
    @communities = @user.communities.active.page(params[:page]).per(10)
  end

  private

  # ユーザー自身の情報編集・退会のみを許可
  def ensure_correct_user
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = current_user
    end

    unless @user == current_user
      redirect_to user_path(current_user), alert: "権限がありません。"
    end
  end

  # 退会済ユーザーがログイン後、限定的なアクションにアクセスできないようにする
  def ensure_active_user
    unless current_user.is_active
      # ログイン阻止はsessions#createで処理済みだが、念の為ここでガード
      redirect_to root_path, alert: "退会済みのためアクセスできません。" and return
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :introduction, :bike_type, :riding_pace, :profile_image)
  end
end