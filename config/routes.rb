Rails.application.routes.draw do

  # devise_for :users
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "posts#index"

  
  resources :posts
  resources :users, only:[:show, :index]
  resources :comments, only:[:create,:destroy]
end

