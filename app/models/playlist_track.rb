class PlaylistTrack < ApplicationRecord
  belongs_to :playlist
  belongs_to :track

  def self.create_plt(playlist, track)
    PlaylistTrack.create(playlist: playlist, track: track)
    playlist.increment
  end
end
