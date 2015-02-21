Rails.application.routes.draw do

  root to: 'pages#frontpage'
  devise_for :users

  resources :gateways

end
