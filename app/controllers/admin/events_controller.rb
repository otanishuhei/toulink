class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_event, only: [:show, :update]

  def index
    @events = Event.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def update
    if @event.suspended?
      if @event.recruiting!
        flash[:notice] = "イベント「#{@event.title}」の管理者権限による停止を解除しました（募集中に変更）"
        redirect_to admin_event_path(@event)
      else
        flash.now[:alert] = "ステータスの更新に失敗しました"
        render :show
      end
    else
      if @event.suspended!
        flash[:notice] = "イベント「#{@event.title}」を管理者権限で停止しました"
        redirect_to admin_event_path(@event)
      else
        flash.now[:alert] = "ステータスの更新に失敗しました"
        render :show
      end
    end
  end

  private
  def set_event
    @event = Event.find_by(id: params[:id])
    unless @event
      flash[:alert] = "指定されたイベントは見つかりませんでした。"
      redirect_to admin_events_path and return
    end
  end
end
