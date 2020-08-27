class Track < ApplicationRecord
  has_many :playlist_tracks
  belongs_to :user
end
