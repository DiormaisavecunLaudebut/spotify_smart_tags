Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  raise
end


def fetch_spotify_data
  rsp_user = RSpotify::User.find(user.spotify_client)
  current_user = User.find {|i| i.spotify_client == user.spotify_client}
  raise
  rsp_user.playlists.each do |playlist|
    check1 = current_user.playlists.find { |i| i.url == playlist.id }
    create_playlist unless check1

    playlist.tracks.each do |track|
      check2 = current_user.tracks.find { |i| i.url == track.id }
      create_track unless check2
    end
  end
end

def create_playlist(playlist)
    url = playlist.id
    name = playlist.name
    cover_url = playlist.images.first['url']

    Playlist.create(user: current_user, url: url, cover_url: cover_url)
end

def create_track(track)
  name = track.name
  artist = track.artists.first.name
  url = track.id
  cover_url = track.album.images.first['url']

  Track.create(user: current_user, url: url, cover_url: cover_url, artist: artist)
end
