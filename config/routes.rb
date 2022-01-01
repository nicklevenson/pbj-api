Rails.application.routes.draw do
  get '/authenticate-google', to: 'sessions#authenticate_google'
  get '/authenticate-facebook', to: 'sessions#authenticate_facebook'
  get '/authenticate-spotify', to: 'sessions#authenticate_spotify'
  get 'auth/:provider/callback', to: 'users#create'

  get 'users/:id/connected_users', to: 'users#get_connected_users'
  get 'users/:id/recommended_users', to: 'users#get_recommended_users'
  get 'users/:id/incoming_requests', to: 'users#get_incoming_requests'
  get 'users/:id/get_supporting_info/:other_user_id', to: 'users#get_supporting_info'
  get 'users/:id/get_user_chatrooms', to: 'users#get_user_chatrooms'
  get 'users/:id/get_user_notifications', to: 'users#get_user_notifications'
  get 'users/:id/unsubscribe', to: 'users#unsubscribe_to_email', as: :unsubscribe_to_email
  post 'users/:id/request_connection', to: 'users#request_connection'
  post 'users/:id/accept_connection', to: 'users#accept_connection'
  post 'users/:id/reject_connection', to: 'users#reject_connection'
  post 'users/:id/reject_user', to: 'users#reject_user'
  post 'users/:id/upload_photo', to: 'users#upload_photo'
  post 'messages/make_read', to: 'messages#make_read'

  post 'notifications/make_read', to: 'notifications#make_read'

  get 'lists/get-instruments', to: 'lists#get_instruments'
  get 'lists/get-genres', to: 'lists#get_genres'
  get 'lists/get-cities', to: 'lists#get_cities'

  resources :messages
  resources :posts
  resources :notifications
  resources :users
end
