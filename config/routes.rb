# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'

  resources :posts
  resources :users, only: %i[show index]
  resources :comments, only: %i[create destroy update edit]
  resources :likes, only: %i[create destroy]
  resources :friendships, only: %i[create update destroy]
end
