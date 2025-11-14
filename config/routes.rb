Rails.application.routes.draw do
  # Devise認証（管理者/ユーザー）
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }
  devise_for :users, skip: [:passwords], controllers: {
    sessions: 'public/sessions',
    registrations: 'public/registrations',
  }

  ## -- ユーザー側 (Public) ルーティング --
  scope module: :public do
    # ホーム・静的ページ
    root 'homes#top'
    get 'about' => 'homes#about'
    get 'privacy' => 'homes#privacy_policy'
    get 'terms' => 'homes#terms_of_service'

    # Users（会員）
    resources :users, only: [:index, :show] do
      get 'followings' => 'relationships#followings', on: :member
      get 'followers' => 'relationships#followers', on: :member
      resource :follows, only: [:create, :destroy]
    end

    # マイページ関連の個別ルーティング
    get 'mypage' => 'users#mypage', as: 'mypage'
    get 'mypage/edit' => 'users#edit', as: 'edit_mypage'
    patch 'mypage' => 'users#update', as: 'update_mypage'
    put 'mypage' => 'users#update'

    # 退会機能
    get 'mypage/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
    patch 'mypage/withdraw' => 'users#withdraw', as: 'withdraw'

    # マイページ内サブメニュー
    get 'mypage/likes' => 'users#likes', as: 'mypage_likes'
    get 'mypage/comments' => 'users#comments', as: 'mypage_comments'
    get 'mypage/communities' => 'users#communities', as: 'mypage_communities'

    # Posts（投稿）
    resources :posts do
      resource :likes, only: [:create, :destroy]
      resources :comments, only: [:create]
      patch 'withdraw' => 'posts#withdraw', on: :member
    end

    # コメントの論理削除
    patch 'comments/:id/withdraw' => 'comments#withdraw', as: 'comment_withdraw'

    # Communities（コミュニティ）
    resources :communities do
      resource :community_members, only: [:create, :destroy]
      get 'confirm_delete' => 'communities#confirm_delete', on: :member
      patch 'withdraw' => 'communities#withdraw', on: :member
    end

    # タグ検索
    get 'tags/:tag_name' => 'posts#index', as: 'tag_posts'
  end

  ## -- 管理者側 (Admin) ルーティング --
  namespace :admin do
    root 'homes#top' # 管理者ダッシュボード

    resources :users, only: [:index, :show, :update]
    resources :posts, only: [:index, :show, :update]
    resources :comments, only: [:index, :update]
    resources :communities, only: [:index, :show, :update]
    resources :tags, only: [:index, :create, :edit, :update]
  end
end