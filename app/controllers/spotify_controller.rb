require 'base64'
require 'httparty'

class SpotifyController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[get_token]
  before_action :refresh_user_token!, only: :fetch_spotify_data

  def spotify_token
    path = 'https://accounts.spotify.com/api/token'
    code = params['code']

    resp = HTTParty.post(path, body: helpers.token_body(code))

    if current_user.spotify_token.nil?
      SpotifyToken.create_token(current_user, resp)
      current_user.connectors << 'Spotify'
      current_user.save
    else
      update_spotify_token(resp)
    end
  end

  def data
    current_user.fetch_spotify_data

    redirect_to root_path
  end

  def gather_user_data_from_spotify
    spotify_token
    redirect_to lior_path
  end

  def create_spotify_playlist
    path = "https://api.spotify.com/v1/users/#{current_user.spotify_client}/playlists"
    content_type = 'application/json'

    max_tracks = current_user.get_permissions[:max_tracks]
    self_destroy = params['Self-destroy']

    uris = params['track-uris'].split('$$').map { |i| "spotify:track:#{i}" }

    uris = uris.sample(max_tracks) unless max_tracks == 'unlimited'

    resp = SpotifyApiCall.post(
      path,
      current_user.token,
      helpers.create_playlist_body(params),
      content_type
    )

    playlist = Playlist.create_playlist(resp, current_user)
    TracklandPlaylist.create_playlist(current_user, params, playlist)
    UpdateCoverUrlJob.set(wait: 2.minutes).perform_later(playlist.id, current_user.id)

    DestroyPlaylistJob.set(wait: 24.hours).perform_later(current_user.id, playlist.id) if self_destroy

    fill_playlist_with_tracks(playlist, uris)

    @playlist_url = playlist.external_url
  end

  private

  def fill_playlist_with_tracks(playlist, uris)
    path = "https://api.spotify.com/v1/playlists/#{playlist.spotify_id}/tracks"
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

    tracks = spotify_ids.map { |id| Track.where(spotify_id: id).take }

    tracks.each do |track|
      user_track = UserTrack.create(user: current_user, track: track)
      UserPlaylistTrack.create(playlist: playlist, user_track: user_track)
    end

    fill_playlist_with_tracks(playlist, uris) unless uris.empty?
  end
end
