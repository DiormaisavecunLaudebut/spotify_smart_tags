require 'Base64'

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :refresh_data!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def refresh_data!
    return if current_user.nil? || current_user.data_updates.empty? || current_user.last_update('spotify') != Date.today.all_day

    refresh_user_token!
    DataUpdate.create(user: current_user, source: 'spotify')
    UpdateSpotifyDataJob.perform_later(current_user.id)
  end

  def refresh_user_token!
    return if current_user.nil? || current_user.spotify_token.nil? || current_user.valid_token? == true

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

  def set_cover_url(arr)
    cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"
    arr.nil? || arr.empty? ? cover_placeholder : arr.first['url']
  end

  def to_boolean(string)
    string == "on"
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

  def track_info(track, tag_name = nil)
    tags = track.tag_list
    tags.delete(tag_name) if tag_name
    [
      track.name,
      track.artist,
      track.cover_url,
      track.external_url,
      track.id,
      tags
    ].join('**')
  end
end
