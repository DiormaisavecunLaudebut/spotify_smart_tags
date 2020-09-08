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

  def token_body(code)
    {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: "http://localhost:3000/auth/spotify/callback",
      client_id: ENV['SPOTIFY_CLIENT'],
      client_secret: ENV['SPOTIFY_SECRET']
    }
  end

  def spotify_api_call(path, options = {})
    HTTParty.get(
      path,
      headers: { Authorization: current_user.token },
      query: options.to_query
    ).parsed_response
  end
end
