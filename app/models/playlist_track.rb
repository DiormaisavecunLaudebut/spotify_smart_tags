class PlaylistTrack < ApplicationRecord
  belongs_to :playlist
  belongs_to :track

  def self.find_or_create(playlist, track)
    PlaylistTrack.where(playlist: playlist, track: track).take || PlaylistTrack.create(playlist: playlist, track: track)
  end
end
