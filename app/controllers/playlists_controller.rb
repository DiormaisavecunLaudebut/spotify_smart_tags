class PlaylistsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :spotify_authenticate

  def show
  end

  def index
    @cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"

    @playlists = user.playlists
  end
end

    # @spotify_token = ENV["SPOTIFY_TOKEN"]
    # @url = "https://accounts.spotify.com/authorize?client_id=#{@spotify_client}&response_type=code&redirect_uri=http://localhost:3000/&scope=user-read-private"
