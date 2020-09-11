class TracklandPlaylist < ApplicationRecord
  belongs_to :user
  belongs_to :playlist

  def self.create_playlist(user, params, playlist)
    name_set = params['name'] == params['name2'] ? false : true
    tags = params['name2'].split(',')

    TracklandPlaylist.create(
      name: params['name'],
      playlist: playlist,
      name_set: name_set,
      tags: tags,
      user: user
    )
  end
end
