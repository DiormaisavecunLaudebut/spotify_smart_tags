require 'base64'
require 'httparty'

class SpotifyController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[get_token]
  before_action :refresh_user_token!, only: :fetch_spotify_data

  def spotify_token
    path = 'https://accounts.spotify.com/api/token'
    code = params['code']

    resp = HTTParty.post(path, body: helpers.token_body(code))

    puts resp

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
end
