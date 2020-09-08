class Playlist < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  belongs_to :user

  def self.find_playlist(spotify_id, user)
    Playlist.where(spotify_id: spotify_id, user: user).take
  end

  def update_track_count(total)
    update!(track_count: total) if track_count != total
  end

  def self.create_playlist(sp, user)
    cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"
    cover_url = sp['images'].nil? || sp['images'].empty? ? cover_placeholder : sp['images'].first['url']
    Playlist.create(
      user: user,
      name: sp['name'],
      cover_url: cover_url,
      description: sp['description'],
      href: sp['href'],
      external_url: sp['external_urls']['spotify'],
      spotify_id: sp['id'],
      track_count: sp['total'].nil? ? 0 : sp['total']
    )
  end

  def increment
    update(track_count: self.track_count += 1)
  end

  def self.find_or_create(sp, user)
    Playlist.find_playlist(sp['id'], user) || Playlist.create_playlist(sp, user)
  end
end
