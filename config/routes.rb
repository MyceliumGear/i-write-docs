Rails.application.routes.draw do

  root to: 'pages#frontpage'
  devise_for :users, controllers: { registrations: 'devise_registrations'}

  resources :orders, only: [:index]

  resources :gateways do
    resources :orders, only: [:show, :index]
  end

  get  'wizard', to: 'wizard#step'
  post 'wizard', to: 'wizard#create_gateway'

end
