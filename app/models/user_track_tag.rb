class UserTrackTag < ApplicationRecord
  belongs_to :user_track
  belongs_to :tag

  def self.find_or_create(user_track, tag)
    UserTrackTag.where(user_track: user_track, tag: tag).take || UserTrackTag.create(user_track: user_track, tag: tag)
  end
end
