desc "Check if Spotify's metadata is relevent"

task :evaluate_spotify_task_metadata do
  user = User.where(username: 'pablior').take
  all_ids = user.tracks.map(&:spotify_id)
  path = 'https://api.spotify.com/v1/audio-features'
  r = {
    danceability: [],
    instrumentalness: [],
    speechiness: [],
    valence: []
  }

  until all_ids.empty?
    ids = all_ids.shift(100)

    resp = SpotifyApiCall.get(path, user.token, { ids: ids.join(',') })
    resp['audio_features'].each do |anal|
      r[:danceability] << anal['danceability']
      r[:instrumentalness] << anal['instrumentalness']
      r[:speechiness] << anal['speechiness']
      r[:valence] << anal['valence']
    end
  end
  puts r
end
