Rails.application.routes.draw do

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users
  root to: 'pages#home'
  get 'lior', to: 'pages#lior', as: :lior
  get 'auth/spotify/callback', to: 'spotify#spotify_token'
  post 'user/gather-data', to: 'spotify#gather_user_data_from_spotify', as: :fetch_spotify_data
  post 'create/playlist', to: 'playlists#create_spotify_playlist', as: :create_spotify_playlist
  get 'tag/index', to: 'tags#index', as: :tag_index
  get 'filter/tracks', to: 'tracks#filter_tracks', as: :filter_tracks
  get 'utaggedtracks', to: 'sptags#show_untagged_tracks', as: :show_untagged_tracks

  resources :sptags, only: [:index] do
    get 'showtracks', to: 'sptags#show_tracks'
  end

  resources :tracks, only: [:show] do
    post 'tag', to: 'tracks#add_tags_to_track', as: :add_tag
    delete 'untag', to: 'tracks#remove_tags_to_track', as: :untag
  end

  resources :tags, only: [:index]

  resources :playlists, only: [:show, :index] do
    post 'create_tag', to: 'tracks#create_tag', as: :create_tag
  end
end