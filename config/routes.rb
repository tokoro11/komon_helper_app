Rails.application.routes.draw do
  root "home#index"
  get "home/index"

  resources :matches

  resources :bookings do
    member do
      patch :approve
      patch :reject
      patch :cancel
    end
  end

  resources :match_listings, only: %i[index show new create] do
    resources :match_applications, only: %i[create index] do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
