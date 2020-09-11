class SpotifyToken < ApplicationRecord
  belongs_to :user

  def self.create_token(user, resp)
    SpotifyToken.create(
      user: user,
      expires_at: Time.now + resp['expires_in'],
      refresh_token: resp['refresh_token'],
      code: resp['access_token']
    )
  end
end
