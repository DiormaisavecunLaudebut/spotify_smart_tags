require 'Base64'

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :refresh_user_token!
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

    resp = refresh_token.parsed_response
    update_spotify_token(resp)
  end

  def update_spotify_token(resp)
    token = SpotifyToken.where(user: current_user).take
    token.update!(expires_at: Time.now + resp['expires_in'], code: resp['access_token'])
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

  def refresh_token
    client_id = ENV['SPOTIFY_CLIENT']
    client_secret = ENV['SPOTIFY_SECRET']
    client_id_and_secret = Base64.strict_encode64("#{client_id}:#{client_secret}")
    result = HTTParty.post(
      "https://accounts.spotify.com/api/token",
      :body => {:grant_type => "refresh_token",
              :refresh_token => "#{current_user.spotify_token.refresh_token}"},
    :headers => {"Authorization" => "Basic #{client_id_and_secret}"}
    )
  end
end
