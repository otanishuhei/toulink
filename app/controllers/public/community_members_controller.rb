class Public::CommunityMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community

  def create
    if @community.community_members.include?(current_user)
      flash[:alert] = "すでに参加しています"
    else
      @community.community_members.create(user: current_user, role: :member)
      flash[:notice] = "コミュニティに参加しました"
    end
    redirect_to community_path(@community)
  end

  def destroy
    membership = @community.community_members.find_by(user: current_user)
    if membership
      membership.destroy
      flash[:notice] = "コミュニティから退会しました"
    else
      flash[:alert] = "参加していません"
    end
    redirect_to community_path(@community)
  end

  private
    def set_community
      @community = Community.find(params[:community_id])
    end
end
