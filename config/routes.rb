Rails.application.routes.draw do

  root to: 'pages#frontpage'
  devise_for :users, controllers: { registrations: 'devise_registrations'}


  resources :orders, only: [:index]

  resources :gateways do
    resources :orders, only: [:show, :index]
  end

end
