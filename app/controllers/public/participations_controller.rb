class Public::ParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_participation, only: [:destroy, :approve, :reject]
  before_action :check_event_organizer, only: [:approve, :reject]

  def create
    @event = Event.find(params[:event_id])

    if @event.participations.exists?(user_id: current_user)
      flash[:alert] = "すでに参加申請、または参加確定済みです"
      redirect_to community_event_path(@event.community, @event) and return
    end

    @participation = current_user.participations.new(event_id: @event.id)

    if @participation.save
      redirect_to community_event_path(@event.community, @event), notice: "イベント参加を申請しました。主催者の承認をお待ち下さい。"
    else
      redirect_to community_event_path(@event.community, @event), alert: "参加申請に失敗しました。: #{@participation.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @participation = Participation.find(params[:id])
    @event = @participation.event

    unless @participation.user == current_user
      flash[:alert] = "権限がありません"
      redirect_to community_event_path(@event.community, @event) and return
    end

    if @participation.destroy
      if @participation.confirmed?
        notice_message = "参加をキャンセルしました"
      else
        notice_message = "参加の申請を取り消ししました"
      end
      redirect_to community_event_path(@event.community, @event), notice: notice_message
    else
      redirect_to community_event_path(@event.community, @event), alert: "キャンセルの処理に失敗しました"
    end
  end

  def approve
    if @participatoin.update(status: :confirmed)
      redirect_to community_event_path(@event.community, @event), notice: "#{@participation.user.name}さんの参加を承認しました"
    else
      redirect_to community_event_path(@event.community, @event), alert: "承認処理に失敗しました"
    end
  end

  def reject
    if @participatoin.update(status: :rejected)
      redirect_to community_event_path(@event.community, @event), alert: "#{@participation.user.name}さんの参加を却下しました"
    else
      redirect_to community_event_path(@event.community, @event), alert: "却下処理に失敗しました"
    end
  end

  private

  def set_participation
    @participation = Participation.find_by(id: params[:id])
    if @participation
      @event = @participation.event
    else
      redirect_to root_path, alert: "対象の参加レコードが見つかりません"
    end
  end

  def check_event_organizer
    unless @event.organizer == current_user
      redirect_to community_event_path(@event.community, @event), alert: "参加申請の承認・却下権限がありません"
    end
  end
end