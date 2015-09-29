IWriteDocs::Engine.routes.draw do
  root to: "pages#show"
  get "diff", to: "pages#diff", as: :diff
  get "*page", to: "pages#show", as: :page
  post "version", to: "pages#version", as: :version
end
