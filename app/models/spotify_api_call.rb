require 'httparty'

class SpotifyApiCall < ApplicationRecord
  belongs_to :user

  def self.get(path, token, options = {})
    SpotifyApiCall.create(path: path)

    HTTParty.get(
      path,
      headers: { Authorization: token },
      query: options.to_query
    ).parsed_response
  end

  def self.get_playlists(token, offset = 0)
    path = 'https://api.spotify.com/v1/me/playlists'
    limit = 50
    options = { limit: limit, offset: offset }

    SpotifyApiCall.get(path, token, options)
  end

  def self.get_albums(token, offset = 0)
    path = 'https://api.spotify.com/v1/me/albums'
    limit = 50
    options = { limit: limit, offset: offset }

    SpotifyApiCall.get(path, token, options)
  end

  def self.get_liked_songs(token, offset = 0)
    path = 'https://api.spotify.com/v1/me/tracks'
    limit = 50
    options = { limit: limit, offset: offset }

    SpotifyApiCall.get(path, token, options)
  end

  def self.get_playlist_tracks(token, playlist_id, offset = 0)
    path = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"
    limit = 100
    options = { limit: limit, offset: offset }

    SpotifyApiCall.get(path, token, options)
  end

  def self.post(path, token, body, content_type = false, encoded_clients = nil)
    call = SpotifyApiCall.create(path: path)

    body = body.to_json if content_type == 'application/json'

    HTTParty.post(
      path,
      headers: call.build_headers(content_type, token, encoded_clients),
      body: body
    ).parsed_response
  end

  def self.delete(path, token)
    SpotifyApiCall.create(path: path)

    HTTParty.delete(
      path,
      headers: { Authorization: token }
    ).parsed_response
  end

  def build_headers(content_type, token, encoded_clients)
    if content_type == 'application/json'
      { "Authorization" => token, "Content-Type" => content_type }
    elsif token == false
      { "Authorization" => "Basic #{encoded_clients}" }
    else
      { "Authorization" => token }
    end
  end
end
