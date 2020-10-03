class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[lior]
  before_action :authenticate_user!

  def home
    @max_filters = current_user.get_permissions[:max_filters]

    @tags = Tag.select_user_scope(current_user).map(&:name).first(6)
    @user_tags = UserTag.select_user_scope(current_user).map(&:name)
    @used_tags = @tags

    @trackland_playlists = current_user.trackland_playlists.sort_by(&:created_at).reverse
  end

  def create_playlist_modal
    tracks = params['track-ids'].split('$$').map { |i| Track.find(i) }
    @name = params['tags']
    @description = "Playlist generated from Trackland the #{Date.today} with the following tags: #{@input_name}"
    @ids = tracks.map(&:spotify_id).join('$$')
  end

  def account
  end

  def lior
    @url = build_spotify_code_url
  end

  def build_spotify_code_url
    redirect_uri = "http://localhost:3000/auth/spotify/callback"
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
      redirect_uri: redirect_uri,
      scope: scope,
      show_dialog: false
    }
    "https://accounts.spotify.com/authorize?" + options.to_query
  end
end
