class Playlist < ApplicationRecord
  has_many :playlist_tracks
  belongs_to :user

  def self.exists?(playlist)
    current_user.playlists.find { |i| i.url == playlist.id }
  end
end
