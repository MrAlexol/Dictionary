Rails.application.routes.draw do
  
  # get 'cards', to: 'cards#index'
  # post 'cards', to: 'cards#create'
  # get 'cards/:id', to: 'cards#show'
  # delete 'cards/:id', to: 'cards#destroy'
  
  resources :cards, only: %i[index create show destroy]
  #devise_for :users
  get 'sessions/logout'
  root 'searches#new'
  #devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }

  resources :words
  resources :searches
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
