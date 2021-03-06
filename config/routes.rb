
Rails.application.routes.draw do

  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => "/cable"

  devise_for :users, controllers: { registrations: "registrations" }
  post 'sort-tag-preference', to: 'users#sort_tag_preference'
  post 'sort-playlist-preference', to: 'users#sort_playlist_preference'


  post 'filter-all', to: 'users#filter_all_option', as: :filter_all

  root to: 'pages#home'
  get 'export-csv', to: 'users#users_export', as: :export_csv
  get 'lior', to: 'pages#lior', as: :lior
  get 'albums', to: 'playlists#albums', as: :albums
  get 'search-tracks', to: 'tracks#search_tracks', as: :search_tracks
  get 'create-playlist-modal', to: 'pages#create_playlist_modal', as: :create_modal
  get 'account', to: 'pages#account', as: :account
  get 'auth/spotify/callback', to: 'spotify#gather_user_data_from_spotify'
  post 'user/gather-data', to: 'spotify#gather_user_data_from_spotify', as: :fetch_spotify_data
  post 'spotify_update_preference', to: 'users#spotify_update_preference', as: :spotify_update_preference
  post 'create/playlist', to: 'spotify#create_spotify_playlist', as: :create_spotify_playlist
  get 'tag/index', to: 'tags#index', as: :tag_index
  get 'bulk-modal', to: 'tags#bulk_modal', as: :bulk_modal
  get 'filter-user-tracks', to: 'user_tracks#filter', as: :filter
  get 'utaggedtracks', to: 'sptags#show_untagged_tracks', as: :show_untagged_tracks
  get 'tag/select', to: 'tags#select_tag', as: :select_tag
  get 'data', to: 'spotify#data', as: :data
  post 'add-tags', to: 'tags#bulk_add_tags', as: :add_tags

  resources :sptags, only: [:index] do
    get 'showtracks', to: 'sptags#show_tracks'
  end

  resources :user_tracks do
    get 'show-tags', to: 'user_tracks#show_tags', as: :show_tags
    post 'tag', to: 'tags#add_tag', as: :add_tag
    post 'remove-tag', to: 'tags#remove_tag', as: :remove_tag
  end
  resources :tracks, only: [:show] do
    delete 'untag', to: 'tracks#remove_tags_to_track', as: :untag
  end

  resources :tags, only: [:index, :show]

  resources :playlists, only: [:show, :index] do
    post 'create_tag', to: 'tracks#create_tag', as: :create_tag
    post 'add-tag', to: 'playlists#add_tag', as: :bulk_tag
    get 'modal', to: 'playlists#modal', as: :modal
  end
end
