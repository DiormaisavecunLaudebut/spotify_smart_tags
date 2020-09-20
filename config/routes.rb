Rails.application.routes.draw do

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { registrations: "registrations" }

  post 'filter-all', to: 'users#filter_all_option', as: :filter_all

  root to: 'pages#home'
  get 'lior', to: 'pages#lior', as: :lior
  get 'account', to: 'pages#account', as: :account
  get 'auth/spotify/callback', to: 'spotify#gather_user_data_from_spotify'
  post 'user/gather-data', to: 'spotify#gather_user_data_from_spotify', as: :fetch_spotify_data
  post 'create/playlist', to: 'playlists#create_spotify_playlist', as: :create_spotify_playlist
  get 'tag/index', to: 'tags#index', as: :tag_index
  get 'filter/tracks', to: 'tracks#filter_tracks', as: :filter_tracks
  get 'utaggedtracks', to: 'sptags#show_untagged_tracks', as: :show_untagged_tracks
  get 'tag/select', to: 'tags#select_tag', as: :select_tag
  post 'add-tags', to: 'tags#bulk_add_tags', as: :add_tags

  resources :sptags, only: [:index] do
    get 'showtracks', to: 'sptags#show_tracks'
  end

  resources :tracks, only: [:show] do
    get 'modal', to: 'tracks#show_tracks_actions', as: :show_tracks_actions
    get 'track/tags', to: 'tracks#show_tags', as: :show_tags
    post 'tag', to: 'tags#add_tag', as: :add_tag
    post 'remove-tag', to: 'tags#remove_tag', as: :remove_tag
    delete 'untag', to: 'tracks#remove_tags_to_track', as: :untag
    get 'napster', to: 'tags#tags_suggestions', as: :tags_suggestions
  end

  resources :tags, only: [:index]

  resources :playlists, only: [:show, :index] do
    post 'create_tag', to: 'tracks#create_tag', as: :create_tag
    post 'add-tag', to: 'playlists#add_tag', as: :bulk_tag
    get 'modal', to: 'playlists#show_playlist_actions', as: :show_playlist_actions
  end
end
