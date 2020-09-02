When the user connects to spotify we'll check the spotify Data
Does the playlist exists in the DB ?
  - no:
         1. create the playlist
         2. For each track in the playlist
            - create the relation playlist_track
            - create the track if it doesn't exists
  - yes:
         1. update the playlist track_count (do we need to update other info)
         2. update the tracks within the playlist
