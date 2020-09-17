class Playlist < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :tracks, through: :playlist_tracks
  has_one :trackland_playlist
  belongs_to :user

  def self.find_playlist(spotify_id, user)
    Playlist.where(spotify_id: spotify_id, user: user).take
  end

  def update_track_count(total)
    update!(track_count: total) if track_count != total
  end

  def self.create_playlist(sp, user)
    cover_url = ApplicationController.helpers.set_cover_url(sp['images'])

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

  def unfollow(user)
    path = "https://api.spotify.com/v1/playlists/#{spotify_id}/followers"
    token = user.token

    resp = SpotifyApiCall.delete(path, token)

    # puts resp
    # puts "pablior #{resp.class}"

    TracklandPlaylist.where(playlist: self, user: user).take.destroy
    destroy
  end

  def increment
    update(track_count: self.track_count += 1)
  end

  def self.find_or_create(sp, user)
    Playlist.find_playlist(sp['id'], user) || Playlist.create_playlist(sp, user)
  end
end
