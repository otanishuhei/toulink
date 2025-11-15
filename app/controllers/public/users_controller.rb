class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_active_user, except: [:show, :index]
  before_action :ensure_correct_user, only: [:edit, :update, :unsubscribe, :withdraw]

  def index
    @users = User.active.page(params[:page]).per(20)
  end

  def show
    @user = User.active.find_by(id: params[:id])
    return redirect_to users_path, alert: "このユーザーは存在しません。" unless @user

    @posts = @user.posts.published.order(created_at: :desc).limit(10)
  end

  def mypage
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: "プロフィールを更新しました。"
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @user.update(is_active: false) # 論理削除
    reset_session # 強制ログアウト
    redirect_to new_user_registration_path, notice: "退会処理を実行しました。ご利用いただきありがとうございました。"
  end

  def likes
    # @user = current_user
    # @liked_posts = @user.liked_posts.published.page(params[:page]).per(10)
  end

  def comments
    # @user = current_user
    # @comments = @user.comments.published.order(created_at: :desc).page(params[:page]).per(10)
  end

  def communities
    # @user = current_user
    # @communities = @user.communities.active.page(params[:page]).per(10)
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
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end