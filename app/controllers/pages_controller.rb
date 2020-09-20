require "discogs"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[lior]
  before_action :authenticate_user!

  def home
    @max_filters = current_user.get_permissions[:max_filters]
    @url = build_spotify_code_url
    if current_user.filter_all
      @user_tags = User.all.map { |i| i.sptags.map(&:name) }.join(' ')
      @tags = Sptag.all.sort_by(&:track_count).reverse.map(&:name).first(6)
    else
      @user_tags = current_user.sptags.map(&:name).join(' ')
      @tags = current_user.sptags.sort_by(&:track_count).reverse.map(&:name).first(6)
    end
    @trackland_playlists = current_user.trackland_playlists
  end

  def account
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
