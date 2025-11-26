class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :update]

  def index
    @users = User.all.order(created_at: :desc).page(params[:page]).per(10)

  end

  def show
  end

  def update
    if @user.toggle(:is_active).save
      flash[:notice] = "#{@user.name} の会員ステータスを更新しました"
      redirect_to admin_user_path(@user)
    else
      flash.now[:alert] = "会員ステータスの更新に失敗しました"
      render :show
    end
  end

  private
  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      flash[:alert] = "指定された会員は見つかりませんでした"
      redirect_to admin_users_path and return
    end
  end
end
