Rails.application.routes.draw do
  get '/authenticate-google', to: 'sessions#authenticate_google'
  get '/authenticate-spotify', to: 'sessions#authenticate_spotify'
  get 'auth/:provider/callback', to: 'users#create'

  patch 'users/:id', to: 'users#update'
  get 'users/:id/connected_users', to: 'users#get_connected_users'
  get 'users/:id/recommended_users', to: 'users#get_recommended_users'
  get 'users/:id/incoming_requests', to: 'users#get_incoming_requests'
  get 'users/:id/get_supporting_info/:other_user_id', to: 'users#get_supporting_info'
  get 'users/:id/unsubscribe', to: 'users#unsubscribe_to_email', as: :unsubscribe_to_email
  post 'users/:id/update_tag', to: 'users#update_tag'
  post 'users/:id/request_connection', to: 'users#request_connection'
  post 'users/:id/accept_connection', to: 'users#accept_connection'
  post 'users/:id/reject_connection', to: 'users#reject_connection'
  post 'users/:id/reject_user', to: 'users#reject_user'
  post 'users/:id/upload_photo', to: 'users#upload_photo'

  get 'tags', to: 'tags#index'

  mount ActionCable.server => '/notification_stream'
  mount ActionCable.server => '/chatroom_stream'

  resources :users
end
