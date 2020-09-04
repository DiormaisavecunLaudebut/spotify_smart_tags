Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'lior', to: 'pages#lior', as: :lior
  get 'auth/spotify/callback', to: 'spotify#spotify_token'

  resources :tracks, only: [:show]
  resources :playlists, only: [:show, :index] do
    post 'tag', to: 'tracks#add_tag', as: :add_tag
    delete 'untag', to: 'tracks#remove_tag', as: :untag
    post 'create_tag', to: 'tracks#create_tag', as: :create_tag
  end
end
