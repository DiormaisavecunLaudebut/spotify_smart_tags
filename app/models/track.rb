class Track < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks
  belongs_to :user
  acts_as_taggable_on :tags

  def self.find_track(spotify_id, user)
    Track.where(spotify_id: spotify_id, user: user).take
  end

  def self.create_track(tr, user)
    cover_url = ApplicationController.helpers.set_cover_url(tr['album']['images'])

    Track.create(
      user: user,
      name: tr['name'],
      artist: tr['artists'][0]['name'],
      cover_url: cover_url,
      href: tr['href'],
      duration: tr['duration_ms'],
      external_url: tr['external_urls']['spotify'],
      spotify_id: tr['id']
    )
  end

  def self.find_or_create(tr, user)
    Track.find_track(tr['track']['id'], user) || Track.create_track(tr['track'], user)
  end

  def add_tag(tag, user)
    tag = tag.downcase.capitalize
    self.is_tag = true
    tag_list.add(tag)
    sptag = user.sptags.where(name: tag).take
    sptag ? sptag.update!(track_count: sptag.track_count += 1) : Sptag.create(name: tag, track_count: 1)
    save
  end

  def add_tags(tags, user)
    tags.each do |tag|
      sptag = user.sptags.where(name: tag).take
      sptag ? sptag.update!(track_count: sptag.track_count += 1) : Sptag.create(name: tag, track_count: 1)
    end

    tags = tags.map { |tag| tag.downcase.capitalize }.join(', ')
    self.is_tag = true
    tag_list.add(tags, parse: true)

    save
  end

  def remove_tag(tag, user)
    tag = tag.downcase.capitalize
    tag_list.remove(tag)
    self.is_tag = false if tag_list.count.zero?
    sptag = user.sptags.where(name: tag).take
    sptag.update!(track_count: sptag.track_count -= 1)
    save
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
