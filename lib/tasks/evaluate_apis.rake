desc 'evaluate the differente APIs in order to see which one is the more relevant to use'

task :evaluate_apis do
  user = User.last
  total = user.tracks.count
  apis = {
    discogs: { tracks: 0, tags: 0 },
    jamendo: { tracks: 0, tags: 0 },
    lastfm: { tracks: 0, tags: 0 },
    audiodb: { tracks: 0, tags: 0 },
    napster: { tracks: 0, tags: 0 }
  }

  playlist = Playlist.find(70)
  playlist.user_tracks.map(&:track).each_with_index do |track, index|
    puts "------- Track #{index}/#{total} -------\n"

    # puts "Calling Jamendo"
    # jamendo_path = "https://api.jamendo.com/v3.0/tracks/?client_id=#{ENV['JAMENDO_CLIENT']}&format=json&name=#{track.name}&include=musicinfo"
    # jamendo_resp = HTTParty.get(URI.escape(jamendo_path)).parsed_response
    # if jamendo_resp['headers']['results_count'] > 0
    #   apis[:jamendo][:tags] += jamendo_resp['results'][0]['musicinfo']['tags'].values.flatten.count
    #   apis[:jamendo][:tracks] += 1
    # end

    puts "Calling LastFm"
    lastfm_path = "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&track=#{track.name}&artist=#{track.artist}&api_key=#{ENV['LASTFM_CLIENT']}&format=json"
    lastfm_resp = HTTParty.get(URI.escape(lastfm_path)).parsed_response
    if !lastfm_resp['error'] && !lastfm_resp['track']['toptags'].nil? && lastfm_resp['track']['toptags']
      puts "Track => #{track.name} by #{track.artist}"
      puts "tags => #{lastfm_resp['track']['toptags']['tag']}"
      apis[:lastfm][:tags] += lastfm_resp['track']['toptags']['tag'].count
      apis[:lastfm][:tracks] += 1
    end

    # puts "Calling Discogs"
    # discogs_path = "https://api.discogs.com/database/search?track=#{track.name}&artist=#{track.artist}"
    # discogs_resp = HTTParty.get(URI.escape(discogs_path), headers: { 'Authorization' => "Discogs key=#{ENV['DISCOGS_CLIENT']}, secret=#{ENV['DISCOGS_SECRET']}"}).parsed_response
    # if !discogs_resp['pagination'].nil? && discogs_resp['pagination']['items'] > 0
    #   result = discogs_resp['results'][0]
    #   apis[:discogs][:tags] += [result['genre'], result['style']].flatten.count
    #   apis[:discogs][:tracks] += 1
    # end

    # puts "Calling AudioDB"
    # audiodb_path = "http://theaudiodb.com/api/v1/json/1/searchtrack.php?s=#{track.artist}&t=#{track.name}"
    # audiodb_resp = HTTParty.get(URI.escape(audiodb_path)).parsed_response
    # unless audiodb_resp['track'].nil?
    #   t = audiodb_resp['track'][0]
    #   apis[:audiodb][:tags] += [t['strGenre'], t['strMood'], t['strStyle'], t['strTheme']].compact.count
    #   apis[:audiodb][:tracks] += 1
    # end

    puts "Calling Napster"
    napster_path = "https://api.napster.com/v2.2/search?query=#{track.name}&type=track&artist=#{track.artist}"
    napster_resp = HTTParty.get(URI.escape(napster_path), headers: { "apikey" => ENV['NAPSTER_CLIENT']}).parsed_response

    if napster_resp['meta']['returnedCount'] > 0
      puts "Track => #{track.name} by #{track.artist}"
      tag_ids = napster_resp['search']['data']['tracks'][0]['links']['tags']['ids']
      genre_ids = napster_resp['search']['data']['tracks'][0]['links']['genres']['ids']
      apis[:napster][:tags] += tag_ids.count
      apis[:napster][:tags] += genre_ids.count
      apis[:napster][:tracks] += 1

      [["tags", tag_ids], ["genres", genre_ids]].each do |ids|
        next if ids[1].count.zero?

        path = "https://api.napster.com/v2.2/#{ids[0]}/" + ids[1].join(',')
        resp = HTTParty.get(URI.escape(path), headers: { "apikey" => ENV['NAPSTER_CLIENT']}).parsed_response
        puts "#{ids[0]} => #{resp[ids[0]].map { |i| i['name'] }}"
      end
    end
    puts "\n\n"
  end
  # puts apis
end
