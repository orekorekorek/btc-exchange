Rails.application.routes.draw do
  root to: "transactions#new"
  resources :transactions, only: %i[new create show]
  get '/admin', to: 'admin#show'
end
