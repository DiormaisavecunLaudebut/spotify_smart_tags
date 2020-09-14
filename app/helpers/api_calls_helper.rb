module ApiCallsHelper
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
      public: to_boolean(params['Public']),
      collaborative: to_boolean(params['Collaborative'])
    }
  end

  def discogs_headers
    { 'Authorization' => "Discogs key=#{ENV['DISCOGS_CLIENT']}, secret=#{ENV['DISCOGS_SECRET']}"}
  end
end
