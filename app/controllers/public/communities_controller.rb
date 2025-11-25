class Public::CommunitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_community, only: [:show, :edit, :update, :confirm_delete, :withdraw]
  before_action :ensure_community_owner, only: [:edit, :update, :confirm_delete, :withdraw]

  def index
    @communities = Community.active.order(created_at: :desc)
  end

  def show
    unless @community.is_active? || current_user&.is_admin?
      flash[:alert] = "このコミュニティは現在非公開中です"
      redirect_to communities_path and return
    end

    if user_signed_in?
      @membership = @community.community_members.find_by(user: current_user)
    end

    @community_members = @community.community_members.includes(:user)
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.owned_communities.new(community_params)

    if @community.save
      flash[:notice] = "コミュニティ名「#{@community.name}」を作成し、リーダーとして登録されました"
      redirect_to community_path(@community)
    else
      flash.now[:alert] = "コミュニティの作成に失敗しました"
      render :new
    end
  end

  def edit
  end

  def update
    if @community.update(community_params)
      flash[:notice] = "コミュニティ情報を更新しました"
      redirect_to community_path(@community)
    else
      flash[:alert] = "コミュニティ情報の更新に失敗しました"
      render :edit
    end
  end

  def confirm_delete
  end

  def withdraw
    if @community.update(is_active: false)
      flash[:notice] = "コミュニティ「#{@community.name}」を削除しました"
      redirect_to communities_path
    else
      flash[:alert] = "コミュニティの削除に失敗しました"
      redirect_to community_path(@community)
    end
  end

  private

  def set_community
    @community = Community.find_by(id: params[:id])
    unless @community
      flash[:alert] = "指定されたコミュニティは見つかりませんでした"
      redirect_to communities_path and return
    end
  end

  def ensure_community_owner
    unless @community.owner == current_user
      flash[:alert] = "権限がありません"
      redirect_to community_path(@community)
    end
  end

  def community_params
    params.require(:community).permit(:name, :description, :is_active, :community_image)
  end
end
