class Admin::CommunitiesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_community, only: [:show, :update]

  def index
    @communities = Community.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def update
    if @community.toggle(:is_active).save
      flash[:notice] = "{#@community.name} のステータスを更新しました"
      redirect_to admin_community_path(@community)
    else
      flash.now[:alert] = "コミュニティステータスの更新に失敗しました"
      render :show
    end
  end

  private
    def set_community
      @community = Community.find_by(id: params[:id])
      unless @community
        flash[:alert] = "指定されたコミュニティは見つかりませんでした"
        redirect_to admin_communities_path and return
      end
    end
end
