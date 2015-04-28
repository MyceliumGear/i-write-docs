Rails.application.routes.draw do

  root to: 'pages#frontpage'
  devise_for :users, controllers: { registrations: 'devise_registrations'}

  resources :orders, only: [:index]

  resources :gateways do
    resources :orders, only: [:show, :index]
  end
  resources :widgets

  get  'wizard', to: 'wizard#step'
  post 'wizard', to: 'wizard#create_gateway'
  post 'wizard/detect_site_type', to: 'wizard#detect_site_type'

  get 'docs/(:section)', to: 'pages#docs'

end
