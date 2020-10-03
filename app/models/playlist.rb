class Playlist < ApplicationRecord
  has_many :user_playlist_tracks
  has_many :user_tracks, through: :user_playlist_tracks, dependent: :destroy
  has_one :trackland_playlist, dependent: :destroy
  belongs_to :user

  def update_track_count(total)
    update!(track_count: total) if track_count != total
  end

  def self.create_playlist(sp, user, playlist_type = 'playlist')
    cover_url = ApplicationController.helpers.set_cover_url(sp['images'])
    Playlist.create(
      user: user,
      name: sp['name'],
      cover_url: cover_url,
      description: sp['description'],
      href: sp['href'],
      external_url: sp['external_urls']['spotify'],
      spotify_id: sp['id'],
      track_count: 0,
      playlist_type: playlist_type
    )
  end

  def self.find_or_create_likes(user)
    Playlist.where(user: user, name: "Liked songs").take || Playlist.create(user: user, name: "Liked songs", track_count: 0, playlist_type: "likes")
  end

  def self.find_or_create_album(sp, user)
    Playlist.where(spotify_id: sp['id'], user: user).take || Playlist.create_playlist(sp, user, 'album')
  end

  def self.find_or_create(sp, user)
    Playlist.where(spotify_id: sp['id'], user: user).take || Playlist.create_playlist(sp, user)
  end

  def unfollow(user)
    path = "https://api.spotify.com/v1/playlists/#{spotify_id}/followers"
    token = user.token

    SpotifyApiCall.delete(path, token)

    TracklandPlaylist.where(playlist: self, user: user).take.destroy
    destroy
  end

  def self.sort_by_user_preference(user, playlists)
    preference = user.playlist_sort
    case preference
    when 'tags' then playlists.sort_by { |i| i.user_tracks.select(&:is_tag).count }.reverse
    when 'tracks' then playlists.sort_by(&:track_count).reverse
    when 'name' then playlists.sort_by { |i| ApplicationController.helpers.clean_emoji(i.name)}
    when 'custom' then playlists
    end
  end

  def increment
    update!(track_count: self.track_count += 1)
  end

  def decrement
    update!(track_count: self.track_count -= 1)
  end
end
