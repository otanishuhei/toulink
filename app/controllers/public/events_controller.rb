class Public::EventsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_community_for_nesting, only: [:show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :check_organizer, only: [:edit, :update, :destroy]

  def new
    @community = Community.find(params[:community_id])
    @event = @community.events.new(organizer_id: current_user.id)
  end

  def create
    @community = Community.find(params[:community_id])
    @event = @community.events.new(event_params)
    @event.organizer_id = current_user.id

    if @event.save
      redirect_to community_event_path(@community, @event), notice: "イベントを作成しました"
    else
      render :new
    end
  end

  def show
    @confirmed_participations = @event.participations.confirmed
    @pending_participations = @event.participations.pending

    if user_signed_in?
      @my_participation = @event.participations.find_by(user: current_user)
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to community_event_path(@community, @event), notice: "イベント情報を更新しました"
    else
      render :edit
    end
  end

  def destroy
    if @event.update(is_deleted: true)
      redirect_to community_path(@community), alert: "イベントを削除しました"
    else
      redirect_to community_event_path(@community, @event), alert: "イベントの削除に失敗しました"
    end
  end

  private
    def set_community_for_nesting
      @community = Community.find_by(id: params[:community_id])
    end

    def set_event
      @event = Event.find_by(id: params[:id], is_deleted: false)
      unless @event
        flash[:alert] = "指定されたイベントは見つかりませんでした"
        redirect_to root_path and return
      end
      @community = @event.community
      unless @community
        flash[:alert] = "イベントに紐づくコミュニティ情報が見つかりません"
        redirect_to root_path and return
      end
    end

    def check_organizer
      unless @event.organizer == current_user
        redirect_to community_event_path(@community, @event), alert: "イベントの編集・削除権限がありません"
      end
    end

    def event_params
      params.require(:event).permit(
        :title,
        :description,
        :meeting_place,
        :destination,
        :start_at,
        :max_participants,
        :pace_required,
        :status
      )
    end
end
