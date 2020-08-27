Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'lior', to: 'pages#lior', as: :lior

  resources :tracks, only: [:show]
  resources :playlists, only: [:show, :index]
end
