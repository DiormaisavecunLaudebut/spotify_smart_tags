class Track < ApplicationRecord
  has_many :user_tracks
  has_many :user_playlist_tracks, through: :user_tracks
  has_many :user_track_tags, through: :user_tracks
  has_many :users, through: :user_tracks

  # def self.find_track(spotify_id, user)
  #   Track.where(spotify_id: spotify_id, user: user).take
  # end

  def self.create_track(tr)
    cover_url = ApplicationController.helpers.set_cover_url(tr['album']['images'])

    Track.create(
      name: tr['name'],
      artist: tr['artists'][0]['name'],
      cover_url: cover_url,
      href: tr['href'],
      duration: tr['duration_ms'],
      external_url: tr['external_urls']['spotify'],
      spotify_id: tr['id']
    )
  end

  def self.find_or_create(tr)
    Track.where(spotify_id: tr['track']['id']).take || Track.create_track(tr['track'])
  end

  def tag_list
    user_track_tags.map { |i| i.tag.name }.uniq
  end

  def get_suggestions
    path = "https://api.napster.com/v2.2/search?query=#{name}&type=track&artist=#{artist}"
    resp = HTTParty.get(URI.escape(path), headers: { "apikey" => ENV['NAPSTER_CLIENT']}).parsed_response

    return unless resp['meta']['returnedCount'].positive?

    metadata = resp['search']['data']['tracks'][0]['links']

    genres = ApplicationController.helpers.map_names('genres', metadata)
    tags = ApplicationController.helpers.map_names('tags', metadata)

    spotify_tags.push(genres, tags).flatten.compact.uniq
  end
end
