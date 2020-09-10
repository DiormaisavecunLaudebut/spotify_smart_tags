class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[lior]
  before_action :authenticate_user!

  def home
    @user_tags = current_user.sptags.map(&:name).join(' ')
    @trackland_playlists = current_user.trackland_playlists
  end

  def lior
    @url = build_spotify_code_url
  end

  def build_spotify_code_url
    scope = %w[
      playlist-read-private
      playlist-read-collaborative
      playlist-modify-public
      playlist-modify-private
      user-library-modify
      user-library-read
      ugc-image-upload
      user-read-private
      user-read-email
    ].join(' ')
    options = {
      client_id: ENV['SPOTIFY_CLIENT'],
      response_type: 'code',
      redirect_uri: 'http://localhost:3000/auth/spotify/callback',
      scope: scope,
      show_dialog: false
    }
    "https://accounts.spotify.com/authorize?" + options.to_query
  end
end