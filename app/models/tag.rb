class Tag < ApplicationRecord
  has_many :user_tags
  has_many :users, through: :user_tags

  has_many :user_track_tags
  has_many :user_tracks, through: :user_track_tags

  def self.find_or_create(name)
    Tag.where(name: name).take || Tag.create(name: name)
  end

  def self.select_user_scope(user)
    if user.tag_sort
      Tag.all.sort_by(&:track_count).reverse
    else
      user.user_tags.sort_by(&:track_count).reverse.map(&:tag)
    end
  end

  def self.sort_by_user_preference(user)
    preference = user.tag_sort
    user_tags = user.user_tags

    case preference
    when 'name'       then return user.tags.sort_by(&:name)
    when 'popularity' then return user_tags.sort_by(&:track_count).reverse.map(&:tag)
    when 'date'       then return user_tags.sort_by(&:created_at).reverse.map(&:tag)
    when 'custom'     then return user_tags.sort_by(&:id).map(&:tag)
    end
  end

  def decrement
    update!(track_count: track_count - 1)
  end

  def increment
    update!(track_count: track_count + 1)
  end
end
