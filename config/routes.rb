Rails.application.routes.draw do

  root to: 'pages#frontpage'
  devise_for :users, controllers: { registrations: 'devise_registrations'}

  resources :orders, only: [:index]

  resources :gateways do
    resources :orders, only: [:show, :index]
  end
  resources :widgets
  resources :address_providers, path: 'fiat-payouts'

  resources :updates do
    post :delivery, on: :member
    collection do
      post :deliver_unsent
    end
  end

  get  'wizard', to: 'wizard#step'
  post 'wizard', to: 'wizard#create_gateway'
  post 'wizard/detect_site_type', to: 'wizard#detect_site_type'

  get 'docs/(:section)', to: 'pages#docs'
  get 'test_error_reporting', to: 'pages#test_error_reporting'

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  get 'locales/:locale', to: "locales#switch", as: :change_locale

end
