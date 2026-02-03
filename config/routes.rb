Rails.application.routes.draw do
  # Devise（ログイン/登録）
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in", as: :users_guest_sign_in
  end

  # ルート
  root "home#index"
  get "home/index"

  # マイページ / プロフィール
  resource :mypage, only: [:show]
  resource :profile, only: [:edit, :update]

  # 通知（詳細を開いたら既読化）
  resources :notifications, only: %i[index show]

  # 体育館検索（MVP）
  resources :gyms, only: %i[index show]

  # 予約
  resources :bookings do
    member do
      patch :approve
      patch :reject
      patch :cancel
    end
  end

  # 試合予定
  resources :matches

  # 申請一覧（横断）
  resources :match_applications, only: [:index]

  # 練習試合募集 + 申請（募集配下）
  resources :match_listings, only: %i[index show new create edit update destroy] do
    resources :match_applications, only: %i[create index show] do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  # Health / PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
