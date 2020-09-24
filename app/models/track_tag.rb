class TrackTag < ApplicationRecord
  belongs_to :tag
  belongs_to :track
  beglons_to :user

  validates :name, uniqueness: true
end
