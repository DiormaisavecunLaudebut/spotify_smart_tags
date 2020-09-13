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

  def map_names(type, metadata)
    ids = metadata[type]['ids']
    return nil if ids.count.zero?

    path = "https://api.napster.com/v2.2/#{type}/" + ids.join(',')
    resp = HTTParty.get(URI.escape(path), headers: { "apikey" => ENV['NAPSTER_CLIENT']}).parsed_response
    resp[type].map { |i| i['name'] }.first(3)
  end
end
