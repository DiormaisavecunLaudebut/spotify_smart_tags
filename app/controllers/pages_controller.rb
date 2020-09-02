class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home]

  def home
    @url = build_spotify_code_url
    fetch_spotify_data
  end

  def fetch_spotify_data
    # new_user = user.created_at >= 3.minute.ago
    # update_user_data
    update_user_playlists
  end

  private

  def update_user_playlists(offset = 0)
    path = 'https://api.spotify.com/v1/me/playlists'
    limit = 20
    options = { limit: limit, offset: offset }

    resp = spotify_api_call(path, options)
    playlists = resp['items']
    playlist_count = resp['total']

    playlists.each do |sp|
      playlist = Playlist.find_playlist(sp['id'], current_user) || Playlist.create_playlist(sp, current_user)
      fetch_playlist_tracks(playlist) if playlist.track_count != sp['tracks']['total']
    end

    offset = new_offset(offset, limit, playlist_count)
    update_user_playlists(offset) if offset
  end

  def fetch_playlist_tracks(playlist, offset = 0)
    path = "https://api.spotify.com/v1/playlists/#{playlist.spotify_id}/tracks"
    limit = 100
    options = { limit: limit, offset: offset }

    resp = spotify_api_call(path, options)
    tracks = resp['items']
    track_count = resp['total']

    # TO DO: select the tracks that aren't in the playlist yet (use table playlist_tracks)
    # tracks_ids = tracks.map { |i| i['track']['id'] }
    # tracks_ids.select do |i|
    #   playlist.tracks
    # end

    tracks.each do |tr|
      track = Track.find_track(tr['id'], current_user)
      raise
      if track.nil?
        track = Track.create_track(tr['track'], current_user)
        PlaylistTrack.create(playlist: playlist, track: track)
      end
    end

    offset = new_offset(offset, limit, track_count)
    fetch_playlist_tracks(offset) if offset
  end

  def update_user_data
    api_endpoint = 'https://api.spotify.com/v1/me'

    resp = HTTParty.get(
      api_endpoint,
      headers: { Authorization: current_user.token }
    ).parsed_response

    current_user.add_spotify_data(resp)
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
