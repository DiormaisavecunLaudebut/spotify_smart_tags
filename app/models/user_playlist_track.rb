class UserPlaylistTrack < ApplicationRecord
  belongs_to :user_track
  belongs_to :playlist
end
