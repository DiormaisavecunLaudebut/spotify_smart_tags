class Track < ApplicationRecord
  has_many :playlist_tracks
  belongs_to :user

  def self.find_track(spotify_id, user)
    Track.where(spotify_id: spotify_id, user: user).take
  end

  def self.create_track(tr, user)
    Track.create(
      user: user,
      name: tr['name'],
      artist: tr['artists'][0]['name'],
      cover_url: set_cover_url(tr['album']['images']),
      href: tr['href'],
      duration: tr['duration_ms'],
      external_url: tr['external_urls']['spotify'],
      spotify_id: tr['id']
    )
  end
end
