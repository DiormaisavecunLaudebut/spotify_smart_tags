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
    content_type = 'application/json'
    uris = params['track-uris'].split('$$')
    self_destroy = params['Self-destroy']

    resp = SpotifyApiCall.post(
      path,
      current_user.token,
      helpers.create_playlist_body(params),
      content_type
    )

    playlist = Playlist.create_playlist(resp, current_user)
    TracklandPlaylist.create_playlist(current_user, params, playlist)

    DestroyPlaylistJob.set(wait: 10.minute).perform_later(current_user.id, playlist.id) if self_destroy == 'on'

    fill_playlist_with_tracks(playlist, uris)

    @playlist_url = playlist.external_url

    # pablior
    # create a job to set the cover_url
  end

  private

  def fill_playlist_with_tracks(playlist, uris)
    playlist_id = playlist.spotify_id
    path = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"
    content_type = 'application/json'
    spotify_ids = uris.map { |i| i.gsub('spotify:track:', '') }
    limit = 100
    sp_uris = uris.shift(limit)

    SpotifyApiCall.post(
      path,
      current_user.token,
      { uris: sp_uris },
      content_type
    )

    tracks = spotify_ids.map { |i| Track.where(user: current_user, spotify_id: i).take }
    tracks.each { |track| PlaylistTrack.create_plt(playlist, track) }

    fill_playlist_with_tracks(playlist, uris) unless uris.empty?
  end
end
