Rails.application.routes.draw do
  root 'home#index'
  get '/search', to: 'search#search'
end
