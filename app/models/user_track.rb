class UserTrack < ApplicationRecord
  belongs_to :user
  belongs_to :track

  has_many :user_track_tags
  has_many :tags, through: :user_track_tags

  has_many :user_playlist_tracks
  has_many :playlists, through: :user_playlist_tracks

  def self.find_or_create(user, track)
    UserTrack.where(user: user, track: track).take || UserTrack.create(user: user, track: track)
  end

  def tag_list
    tags.map(&:name)
  end

  def tagged_with(tag_names)
    tag_names = [tag_names] unless tag_names.class == Array

    tag_names.all? { |e| tag_list.include?(e) }
  end

  def add_tags(tag_names, user)
    tag_names = [tag_names] unless tag_names.class == Array

    update!(is_tag: true) unless is_tag

    tag_names.each do |tag_name|
      tag = Tag.find_or_create(tag_name)
      user_tag = UserTag.find_or_create(user, tag)
      user_track_tag = UserTrackTag.where(user_track: self, tag: tag).take

      next unless user_track_tag.nil?

      UserTrackTag.create(user_track: self, tag: tag)
      [user_tag, tag].each(&:increment)
    end
  end

  def remove_tags(tag_names, user)
    tag_names = [tag_names] unless tag_names.class == Array

    tag_names.each do |tag_name|
      tag = Tag.where(name: tag_name).take
      tag.decrement

      user_tag = UserTag.where(user: user, tag: tag).take
      user_tag.decrement

      user_track_tag = UserTrackTag.where(user_track: self, tag: tag).take
      user_track_tag.destroy
    end

    update!(is_tag: false) if tags.empty?
  end
end
