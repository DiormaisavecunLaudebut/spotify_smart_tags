class PlaylistsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :refresh_user_token!, only: :create_spotify_playlist

  def show
    playlist = Playlist.find(params['id'])
    @tracks = playlist.tracks
    @user_tags = current_user.sptags.map(&:name).join(' ')
  end

  def index
    @playlists = current_user.playlists
  end

  def create_spotify_playlist
    path = "https://api.spotify.com/v1/users/#{current_user.spotify_client}/playlists"
    content_type = "application/json"
    set_name = params['name2'] == params['name'] ? false : true

    uris = params['track-uris'].split('$$')

    resp = HTTParty.post(
      path,
      headers: { Authorization: current_user.token, "Content-Type" => content_type },
      body: create_playlist_body(params)
    ).parsed_response

    playlist = Playlist.create_playlist(resp, current_user)

    TracklandPlaylist.create_playlist(current_user, params)

    fill_playlist_with_tracks(playlist, uris)

    @playlist_url = playlist.external_url
    # pablior
    # learn more about the cover_url, maybe create a job too set the cover_url
    # if spotify doesn't update it in real time, otherwise juste create a
    # function right there
  end

  private

  def fill_playlist_with_tracks(playlist, uris)
    playlist_id = playlist.spotify_id
    path = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"
    spotify_ids = uris.map { |i| i.gsub('spotify:track:', '') }
    limit = 100
    sp_uris = uris.shift(limit)

    resp = HTTParty.post(
      path,
      headers: { Authorization: current_user.token, "Content-Type" => content_type },
      body: { uris: sp_uris }.to_json
    )

    tracks = spotify_ids.map { |i| Track.where(user: current_user, spotify_id: i).take }
    tracks.each { |track| PlaylistTrack.create_plt(playlist, track) }

    fill_playlist_with_tracks(playlist, uris) unless uris.empty?
  end

  def create_playlist_body(uris)
    {
      name: params['name'],
      description: params['description'],
      public: to_boolean(params['public']),
      collaborative: to_boolean(params['collaborative'])

    }.to_json
  end
end
