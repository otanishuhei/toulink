class Public::ParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_participation, only: [:destroy, :approve, :reject]
  before_action :check_event_organizer, only: [:approve, :reject]

  def create
    @event = Event.find(params[:event_id])

    if @event.participations.exists?(user_id: current_user.id)
      redirect_to community_event_path(@event.community, @event),
                  alert: "すでに参加申請、または参加確定済みです"
      return
    end

    @participation = current_user.participations.new(event_id: @event.id)

    if @participation.save
      redirect_to community_event_path(@event.community, @event),
                  notice: "イベント参加を申請しました。主催者の承認をお待ち下さい。"
    else
      redirect_to community_event_path(@event.community, @event),
                  alert: "参加申請に失敗しました: #{@participation.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    unless @participation.user == current_user
      redirect_to community_event_path(@event.community, @event),
                  alert: "権限がありません"
      return
    end

    if @participation.destroy
      notice_message = @participation.confirmed? ? "参加をキャンセルしました" : "参加の申請を取り消ししました"
      redirect_to community_event_path(@event.community, @event),
                  notice: notice_message
    else
      redirect_to community_event_path(@event.community, @event),
                  alert: "キャンセルの処理に失敗しました"
    end
  end

  def approve
    update_participation_status(:confirmed, "#{@participation.user.name}さんの参加を承認しました")
  end

  def reject
    update_participation_status(:rejected, "#{@participation.user.name}さんの参加を却下しました", alert:true)
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
        redirect_to community_event_path(@event.community, @event),
                    alert: "参加申請の承認・却下権限がありません"
      end
    end

    def update_participation_status(status, message, alert: false)
      if @participation.update(status: status)
        redirect_to community_event_path(@event.community, @event),
                    notice: (alert ? nil : message),
                    alert: (alert ? message : nil)
      else
        redirect_to community_event_path(@event.community, @event),
                    alert: "#{status}処理に失敗しました"
      end
    end
end
