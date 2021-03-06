module ApiCallsHelper
  def token_body(code)
    redirect_uri = Rails.env == "development" ? "http://localhost:3000/auth/spotify/callback" : "https://trackland.herokuapp.com/auth/spotify/callback"
    {
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: redirect_uri,
      client_id: ENV['SPOTIFY_CLIENT'],
      client_secret: ENV['SPOTIFY_SECRET']
    }
  end

  def create_spotify_token(user, resp)
    SpotifyToken.create(
      user: user,
      expires_at: Time.now + resp['expires_in'],
      refresh_token: resp['refresh_token'],
      code: resp['access_token']
    )
  end

  def refresh_token_body(refresh_token)
    {
      grant_type: 'refresh_token',
      refresh_token: refresh_token
    }
  end

  def create_playlist_body(params)
    {
      name: params['name'].gsub('$$', ', '),
      description: params['description'],
      public: to_boolean(params['Public']),
      collaborative: to_boolean(params['Collaborative'])
    }
  end

  def discogs_headers
    { 'Authorization' => "Discogs key=#{ENV['DISCOGS_CLIENT']}, secret=#{ENV['DISCOGS_SECRET']}"}
  end
end
