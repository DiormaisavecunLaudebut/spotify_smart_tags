class DestroyPlaylistJob < ApplicationJob
  queue_as :default

  def perform(user_id, playlist_id)
    user = User.find(user_id)
    playlist = Playlist.find(playlist_id)

    playlist.unfollow(user)
  end
end
