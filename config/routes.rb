IWriteDocs::Engine.routes.draw do
  root to: "i_write_docs/pages#show"
  get "diff", to: "i_write_docs/pages#diff", as: :diff
  get "*doc", to: "i_write_docs/pages#show", as: :page
  post "version", to: "i_write_docs/pages#version", as: :version
end
