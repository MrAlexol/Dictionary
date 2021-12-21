Rails.application.routes.draw do

  post 'cards/:id/check', to: 'cards#check', as: 'card_check'
  resources :cards, only: %i[index create show destroy]
  get 'sessions/logout'
  root 'searches#new'

  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }
  resources :words, only: %i[show index]
  get 'searches/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
