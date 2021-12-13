Rails.application.routes.draw do
  root 'searches#new'
  resources :words
  resources :searches
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
