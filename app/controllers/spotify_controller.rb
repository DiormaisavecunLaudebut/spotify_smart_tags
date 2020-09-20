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

  def gather_user_data_from_spotify
    spotify_token
    DataUpdate.create(user: current_user, source: 'spotify')
    current_user.fetch_spotify_data

    redirect_to playlists_path
    # pablior
    # need ajax: display loading then display confirmation message
  end
end
