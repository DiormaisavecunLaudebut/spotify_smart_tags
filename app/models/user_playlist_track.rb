class UserPlaylistTrack < ApplicationRecord
  belongs_to :user_track
  belongs_to :playlist

  after_create :increment_playlist
  after_destroy :decrement_playlist

  def self.find_or_create(playlist, user_track)
    UserPlaylistTrack.where(playlist: playlist, user_track: user_track).take || UserPlaylistTrack.create(user_track: user_track, playlist: playlist)
  end

  def increment_playlist
    playlist.increment
  end

  def decrement_playlist
    playlist.decrement
  end
end
