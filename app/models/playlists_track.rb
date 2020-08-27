class PlaylistsTrack < ApplicationRecord
  belongs_to :playlist
  belongs_to :tracks
end
