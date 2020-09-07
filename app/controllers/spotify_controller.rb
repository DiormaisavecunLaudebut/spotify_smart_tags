require 'Base64'
require 'httparty'
require 'open-uri'

class SpotifyController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[get_token]

  def spotify_token
    api_endpoint = 'https://accounts.spotify.com/api/token'

    resp = HTTParty.post(api_endpoint, body: token_body)

    current_user.spotify_token.nil? ? create_spotify_token(resp) : update_spotify_token(resp)
    redirect_to root_path
  end

  def refresh_token; end

  def fetch_spotify_data
    update_user_data
    update_user_playlists_and_tracks
  end

  private

  def update_user_data
    path = 'https://api.spotify.com/v1/me'
    resp = spotify_api_call(path)

    current_user.add_spotify_data(resp)
  end

  def update_user_playlists_and_tracks(offset = 0)
    path = 'https://api.spotify.com/v1/me/playlists'
    limit = 50
    options = { limit: limit, offset: offset }

    resp = spotify_api_call(path, options)
    playlists = resp['items'].select { |i| i['owner']['id'] == current_user.spotify_client }

    playlists.each do |sp|
      playlist = Playlist.find_or_create(sp, current_user)
      fetch_playlist_tracks(playlist) if playlist.track_count != sp['tracks']['total']
    end

    offset = new_offset(offset, limit, resp['total'])
    update_user_playlists_and_tracks(offset) if offset
  end

  def fetch_playlist_tracks(playlist, offset = 0)
    path = "https://api.spotify.com/v1/playlists/#{playlist.spotify_id}/tracks"
    limit = 100
    options = { limit: limit, offset: offset }

    resp = spotify_api_call(path, options)
    tracks = select_non_existing_tracks(playlist, resp['items'])

    tracks.each do |tr|
      track = Track.find_or_create(tr, current_user)
      PlaylistTrack.find_or_create(playlist, track)
    end

    offset = new_offset(offset, limit, resp['total'])
    fetch_playlist_tracks(playlist, offset) if offset
  end

  def select_non_existing_tracks(playlist, tracks)
    existing_ids = playlist.playlist_tracks.map { |i| i.track.spotify_id }
    tracks.reject { |i| existing_ids.include?(i['track']['id']) }
  end

  def create_spotify_token(resp)
    SpotifyToken.create(
      user: current_user,
      expires_at: Time.now + resp['expires_in'],
      refresh_token: resp['refresh_token'],
      code: resp['access_token']
    )
  end

  def token_body
    {
      grant_type: 'authorization_code',
      code: params['code'],
      redirect_uri: "http://localhost:3000/auth/spotify/callback",
      client_id: ENV['SPOTIFY_CLIENT'],
      client_secret: ENV['SPOTIFY_SECRET']
    }
  end
end
