require 'Base64'

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # before_action :refresh_user_token!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def refresh_user_token!
    return unless current_user.valid_token?

    api_endpoint = 'https://accounts.spotify.com/api/token'

    test = refresh_token_header
    resp = HTTParty.post(
      api_endpoint,
      body: refresh_token_body,
      header: test
    )
    update_spotify_token(resp)
  end

  def update_spotify_token(resp)
    token = SpotifyToken.where(user: current_user).take
    token.update(
      expires_at: Date.today + resp['expires_in'].seconds,
      refresh_token: resp['refresh_token'],
      code: resp['access_token']
    )
  end

  end

  def fetch_spotify_data(user)
    new_user = user.created_at >= 3.minute.ago
  end

  def new_offset(offset, limit, total)
    offset + limit < total ? offset += limit : nil
  end

  def spotify_api_call(path, options = {})
    HTTParty.get(
      path,
      headers: { Authorization: current_user.token },
      query: options.to_query
    ).parsed_response
  end

  def set_cover_url(arr)
    cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"
    arr.nil? || arr.empty? ? cover_placeholder : arr.first['url']
  end

  def refresh_token_header
    encoded_id = Base64.encode64(ENV['SPOTIFY_CLIENT'])
    encoded_secret = Base64.encode64(ENV['SPOTIFY_SECRET'])
    auth_encoded = (encoded_id + encoded_secret).delete("\n")
    "Authorization: Basic " + auth_encoded
  end

  def refresh_token_body
    {
      grant_type: "refresh_token",
      refresh_token: current_user.spotify_token.refresh_token
    }
  end
