class UserPlaylistTrack < ApplicationRecord
  belongs_to :user_track
  belongs_to :playlist

  after_create :increment_playlist
  after_destroy :decrement_playlist

  def increment_playlist
    playlist.increment
  end

  def decrement_playlist
    playlist.decrement
  end
end
