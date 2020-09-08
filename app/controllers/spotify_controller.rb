require 'Base64'
require 'httparty'
require 'open-uri'

class SpotifyController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[get_token]
  before_action :refresh_user_token!, only: :fetch_spotify_data

  def spotify_token
    path = 'https://accounts.spotify.com/api/token'
    code = params['code']

    resp = HTTParty.post(path, body: helpers.token_body(code))

    if current_user.spotify_token.nil?
      helpers.create_spotify_token(current_user, resp)
    else
      update_spotify_token(resp)
    end

    redirect_to root_path
  end

  def gather_user_data_from_spotify
    DataUpdate.create(user: current_user, source: 'spotify')
    current_user.fetch_spotify_data('now')

    redirect_to playlists_path
    # pablior
    # need ajax: display loading then display confirmation message
  end

  private

  def update_user_data
    path = 'https://api.spotify.com/v1/me'
    resp = helpers.spotify_api_call(path)

    current_user.add_spotify_data(resp)
  end

  def update_user_playlists_and_tracks(offset = 0, my_playlists = current_user.playlists.map(&:id))
    path = 'https://api.spotify.com/v1/me/playlists'
    limit = 50
    options = { limit: limit, offset: offset }

    resp = helpers.spotify_api_call(path, options)
    playlists = resp['items'].select { |i| i['owner']['id'] == current_user.spotify_client }

    playlists.each do |sp|
      playlist = Playlist.find_playlist(sp['id'], current_user)
      if playlist
        my_playlists.delete(playlist.id)
      else
        playlist = Playlist.create_playlist(sp, current_user)
      end
      fetch_playlist_tracks(playlist) if playlist.track_count != sp['tracks']['total']
    end

    offset = new_offset(offset, limit, resp['total'])
    offset ? update_user_playlists_and_tracks(offset, my_playlists) : delete_remaining_playlists(my_playlists)
  end

  def delete_remaining_playlists(playlists)
    playlists.map { |i| Playlist.find(i) }.each do |playlist|
      playlist.destroy
      playlist.tracks.each { |track| track.destroy if track.playlist_tracks.empty? }
    end
  end

  def fetch_playlist_tracks(playlist, offset = 0, my_tracks = [])
    path = "https://api.spotify.com/v1/playlists/#{playlist.spotify_id}/tracks"
    my_tracks = playlist.tracks.map(&:id) if my_tracks.empty?
    limit = 100
    options = { limit: limit, offset: offset }

    resp = helpers.spotify_api_call(path, options)
    tracks = resp['items']

    tracks.each do |tr|
      track = Track.find_track(tr['track']['id'], current_user)
      if track
        my_tracks.delete(track.id)
      else
        track = Track.create_track(tr['track'], current_user)
        PlaylistTrack.create_plt(playlist, track)
      end
    end

    offset = new_offset(offset, limit, resp['total'])
    offset ? fetch_playlist_tracks(playlist, offset, my_tracks) : delete_remaining_tracks(my_tracks)
  end

  def delete_remaining_tracks(tracks)
    tracks.map { |i| Track.find(i) }.each(&:destroy)
  end
end
