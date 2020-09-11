require 'Base64'

module ApplicationHelper
  def pluralise(string, count)
    case count
    when 0 then "aucun #{string}"
    when 1 then "#{count} #{string}"
    else "#{count} #{string}s"
    end
  end

  def create_spotify_token(user, resp)
    SpotifyToken.create(
      user: user,
      expires_at: Time.now + resp['expires_in'],
      refresh_token: resp['refresh_token'],
      code: resp['access_token']
    )
  end

  def set_cover_url(arr)
    cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"
    arr.nil? || arr.empty? ? cover_placeholder : arr.first['url']
  end

  def new_offset(offset, limit, total)
    offset + limit < total ? offset += limit : nil
  end

  def no_data_refresh_needed(user)
    today = Date.today.all_day
    check1 = user.nil?
    check2 = user&.data_updates&.empty?
    check3 = user&.last_update('spotify') == today

    check1 || check2 || check3
  end

  def no_token_refresh_needed(user)
    check1 = user.nil?
    check2 = current_user&.spotify_token.nil?
    check3 = current_user&.valid_token? == true

    check1 || check2 || check3
  end

  def encode_credentials
    client_id = ENV['SPOTIFY_CLIENT']
    client_secret = ENV['SPOTIFY_SECRET']
    Base64.strict_encode64("#{client_id}:#{client_secret}")
  end

  def token_body(code)
    {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: "http://localhost:3000/auth/spotify/callback",
      client_id: ENV['SPOTIFY_CLIENT'],
      client_secret: ENV['SPOTIFY_SECRET']
    }
  end

  def refresh_token_body(refresh_token)
    {
      grant_type: 'refresh_token',
      refresh_token: refresh_token
    }
  end

  def create_playlist_body(params)
    {
      name: params['name'],
      description: params['description'],
      public: to_boolean(params['public']),
      collaborative: to_boolean(params['collaborative'])
    }
  end

  def to_boolean(string)
    %w[on true].include?(string)
  end

  def serialize_track_info(track, tag_name = nil)
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
