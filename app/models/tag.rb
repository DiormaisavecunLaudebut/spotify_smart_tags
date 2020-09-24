class Tag < ApplicationRecord
  has_many :user_tags
  has_many :users, through: :user_tags

  has_many :user_track_tags
  has_many :user_tracks, through: :user_track_tags

  def self.find_or_create(name)
    Tag.where(name: name).take || Tag.create(name: name)
  end

  def decrement
    update!(track_count: track_count - 1)
  end

  def increment
    update!(track_count: track_count + 1)
  end
end
