# frozen_string_literal: true

Rails.application.routes.draw do
  root 'searches#new'

  # Searches
  get 'searches/new', constraints: { format: :html }
  get 'searches/show', constraints: { format: :html }

  # Words
  scope format: true, constraints: { format: :json } do
    resources :words, only: %i[show index]
  end

  # Cards
  post 'cards/:id/check', to: 'cards#check', as: 'card_check', constraints: { format: :json }
  resources :cards, only: %i[index create show destroy]

  # Users
  get 'auth/register', to: 'searches#new'
  devise_scope :user do
    post 'auth/login', to: 'users/sessions#create'
  end
  devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }

  # Unmatched
  match '*unmatched', to: 'application#not_found_no_logs', via: :all

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
