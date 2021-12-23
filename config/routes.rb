# frozen_string_literal: true

Rails.application.routes.draw do
  root 'searches#new'
  get 'searches/new'

  post 'cards/:id/check', to: 'cards#check', as: 'card_check'
  resources :cards, only: %i[index create show destroy]
  get 'auth/register', to: 'searches#new'
  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }
  resources :words, only: %i[show index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
