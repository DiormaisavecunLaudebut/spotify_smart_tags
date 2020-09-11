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

  def add_tags(arr, user)
    self.is_tag = true unless arr.empty?

    arr.each do |tag|
      tag_list.add(tag)
      sptag = user.sptags.where(name: tag).take
      sptag ? sptag.update(track_count: sptag.track_count += 1) : Sptag.create(name: tag, track_count: 1)
    end
    save
  end

  def get_suggestions
    path = "https://api.discogs.com/database/search?track=#{name}&artist=#{artist}"

    resp = HTTParty.get(
      path,
      headers: ApplicationController.helpers.discogs_headers
    ).parsed_response
    if resp['pagination']['items'].zero?
      nil
      # try with another API ?
    else
      result = resp['results'].first
      [result['genre'], result['style']].flatten
    end
  end
end
