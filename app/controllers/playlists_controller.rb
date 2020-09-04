class PlaylistsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    playlist = Playlist.find(params['id'])
    @tracks = playlist.playlist_tracks.map(&:track)
    @user_tags = %w[chill dark bright techno deep_house house minimalist joyful club afrika jazzy vocal instrumental remix sad].join('/')
  end

  def index
    @playlists = current_user.playlists
  end

  def create_tag; end
end
