Rails.application.routes.draw do
  resources :requests
  resources :rejections
  resources :messages
  resources :notifications
  resources :tags
  resources :connections
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
