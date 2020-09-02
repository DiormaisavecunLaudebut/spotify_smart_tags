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

  private

  def token_body
    {
      grant_type: 'authorization_code',
      code: params['code'],
      redirect_uri: "http://localhost:3000/auth/spotify/callback",
      client_id: ENV['SPOTIFY_CLIENT'],
      client_secret: ENV['SPOTIFY_SECRET']
    }
  end

  def create_spotify_token(resp)
    SpotifyToken.create(
      user: current_user,
      expires_at: Time.now + resp['expires_in'],
      refresh_token: resp['refresh_token'],
      code: resp['access_token']
    )
  end
end
