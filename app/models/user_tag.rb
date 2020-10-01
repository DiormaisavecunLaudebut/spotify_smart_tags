class UserTag < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  def self.find_or_create(user, tag)
    UserTag.where(user: user, tag: tag).take || UserTag.create(user: user, tag: tag)
  end

  def self.select_user_scope(user)
    if user.filter_all
      Tag.all
    else
      user.tags
    end
  end

  def decrement
    update!(track_count: track_count - 1)
  end

  def increment
    update!(track_count: track_count + 1)
  end
end
