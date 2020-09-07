Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'lior', to: 'pages#lior', as: :lior
  get 'auth/spotify/callback', to: 'spotify#spotify_token'
  post 'fetch_spotify_data', to: 'spotify#fetch_spotify_data', as: :fetch_spotify_data
  get 'tag/index', to: 'tags#index', as: :tag_index
  get 'filter/tracks', to: 'tracks#filter_tracks', as: :filter_tracks

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
