desc 'delete all playlists generated from Trackland'

task :destroy_all_tlp do
  user = User.where(name: 'pablior').take
  user.trackland_playlists.each do |tlp|
    path = "https://api.spotify.com/v1/playlists/#{tlp.playlist.spotify_id}/followers"
    HTTParty.delete(
      path,
      headers: { Authorization: user.token }
    )
    tlp.playlist.destroy
  end
end
