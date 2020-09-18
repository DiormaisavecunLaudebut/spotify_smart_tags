class UpdateCoverUrlJob < ApplicationJob
  queue_as :default

  def perform(playlist_id, user_id)
    playlist = Playlist.find(playlist_id)
    user = User.find(user_id)
    tlp = TracklandPlaylist.where(playlist: playlist, user: user).take

    token = user.token
    path = "https://api.spotify.com/v1/playlists/#{playlist.spotify_id}/images"

    resp = SpotifyApiCall.get(path, token)
    cover_url = resp.match(/https:.+\d/)[0].strip

    tlp.update!(cover_url: cover_url)
    playlist.update!(cover_url: cover_url)
  end
end
