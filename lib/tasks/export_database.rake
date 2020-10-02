require 'csv'

desc "export database to csv"

task :export_database do
  file = "#{Rails.root}/public/database_export.csv"
  users = User.all

  headers = %w[
    username
    email
    filter_all
    user_track_count
    user_track_tagged_count
    user_tag_count
    playlist_count
    user_playlist_track_count
    trackland_playlist_count
  ]

  CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
    users.each do |user|
      username = user.username
      email = user.email
      filter_all = user.filter_all
      user_track_count = user.user_tracks.count
      user_track_tagged_count = user.user_tracks.select(&:is_tag).count
      user_tag_count = user.user_tags.count
      playlist_count = user.playlists.count
      user_playlist_track_count = user.playlists.map { |i| i.user_playlist_tracks.count }.reduce(&:+)
      trackland_playlist_count = user.trackland_playlists.count

      writer << [
        username,
        email,
        filter_all,
        user_track_count,
        user_track_tagged_count,
        user_tag_count,
        playlist_count,
        user_playlist_track_count,
        trackland_playlist_count
      ]
    end
  end
end
