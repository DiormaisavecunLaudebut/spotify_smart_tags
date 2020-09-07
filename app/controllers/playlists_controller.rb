class PlaylistsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    playlist = Playlist.find(params['id'])
    @tracks = playlist.playlist_tracks.map(&:track)
    @user_tags = current_user.sptags.map(&:name).join(' ')
  end

  def index
    @playlists = current_user.playlists
  end

  # def create_tag; end
end
