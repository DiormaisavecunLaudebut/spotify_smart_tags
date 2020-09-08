class TracklandPlaylist < ApplicationRecord
  belongs_to :user

  def self.create_playlist(user, params)
    name_set = params['name'] == params['name2'] ? false : true
    tags = params['name2'].split(',')

    TracklandPlaylist.create(
      name: params['name'],
      name_set: name_set,
      tags: tags,
      user: user
    )
  end
end
