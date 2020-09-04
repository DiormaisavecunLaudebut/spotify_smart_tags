class Playlist < ApplicationRecord
  has_many :playlist_tracks
  belongs_to :user

  def self.find_playlist(spotify_id, user)
    Playlist.where(spotify_id: spotify_id, user: user).take
  end

  def update_track_count(total)
    update!(track_count: total) if track_count != total
  end

  def self.create_playlist(sp, user)
    Playlist.create(
      user: user,
      name: sp['name'],
      cover_url: set_cover_url(sp['images']),
      description: sp['description'],
      href: sp['href'],
      external_url: sp['external_urls']['spotify'],
      spotify_id: sp['id'],
      track_count: sp['total']
    )
  end

  def self.find_or_create(sp, user)
    Playlist.find_playlist(sp['id'], user) || Playlist.create_playlist(sp, user)
  end
end
