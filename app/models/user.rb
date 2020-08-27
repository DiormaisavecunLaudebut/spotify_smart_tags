class User < ApplicationRecord

  has_many :playlists
  has_many :tracks

  validate :spotify_client_must_exist
  after_validation :fetch_spotify_data

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def email_required?
    false
  end

  def email_changed?
   false
  end

  validates :spotify_client, presence: true, uniqueness: true

  private

  def fetch_spotify_data
    rsp_user = RSpotify::User.find(spotify_client)
    raise
    rsp_user.playlists.each do |playlist|
      create_playlist(playlist)
      playlist.tracks.each { |t| create_track(t) }
    end
  end

  def create_playlist(playlist)
      url = playlist.id
      name = playlist.name
      cover_url = playlist.images.first['url']

      Playlist.create(user: self, url: url, cover_url: cover_url)
  end

  def create_track(track)
    name = track.name
    artist = track.artists.first.name
    url = track.id
    cover_url = track.album.images.first['url']

    Track.create(user: self, url: url, cover_url: cover_url, artist: artist)
  end

  def spotify_client_must_exist
    begin
      user = RSpotify::User.find(spotify_client)
    rescue
      errors.add(:spotify_client, 'this username does not exist')
    end
  end
end
