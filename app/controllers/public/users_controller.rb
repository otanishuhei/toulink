class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_active_user, except: [:show, :index]
  before_action :ensure_correct_user, only: [:edit, :update, :unsubscribe, :withdraw]

  def index
    @users = User.active.order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @user = User.find_by(id: params[:id])
    return redirect_to users_path, alert: "このユーザーは存在しません" unless @user

    @owned_communities = @user.owned_communities
                              .active
                              .includes(:owner)
                              .order(created_at: :desc)
                              .page(params[:owned_page])
                              .per(4)
    @joined_communities = Community.joins(:community_members)
                                  .where(community_members: { user_id: @user.id })
                                  .where.not(owner_id: @user.id)
                                  .active
                                  .distinct
                                  .order(created_at: :desc)
                                  .page(params[:joined_page])
                                  .per(4)
    @created_events = @user.organized_events
                           .where.not(status: [:draft, :suspended])
                           .order(start_at: :desc)
                           .page(params[:events_page])
                           .per(4)
    @posts = @user.posts
                  .published
                  .order(created_at: :desc)
                  .page(params[:post_page])
                  .per(6)
  end

  def mypage
    @user = current_user
    @joined_communities = Community.joined_by(@user.id)
                                   .where(community_members: { user_id: @user.id })
                                   .active
                                   .order(created_at: :desc)
                                   .page(params[:community_page])
                                   .per(4)
    @draft_events = @user.organized_events
                         .where(status: :draft)
                         .order(start_at: :asc)
                         .page(params[:event_page])
                         .per(4)
    @participating_events = Event.joins(:participations)
                                 .where(participations: { user_id: @user.id })
                                 .where(is_deleted: false)
                                 .where.not(status: [:draft, :suspended])
                                 .order(start_at: :asc)
                                 .page(params[:participation_page])
                                 .per(4)
    @posts = @user.posts
                  .published
                  .order(created_at: :desc)
                  .page(params[:post_page])
                  .per(6)
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
