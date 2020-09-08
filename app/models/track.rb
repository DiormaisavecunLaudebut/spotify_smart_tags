class Track < ApplicationRecord
  has_many :playlist_tracks, dependent: :destroy
  has_many :playlists, through: :playlist_tracks
  belongs_to :user
  acts_as_taggable_on :tags

  def self.find_track(spotify_id, user)
    Track.where(spotify_id: spotify_id, user: user).take
  end

  def self.create_track(tr, user)
    arr = tr['album']['images']
    cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"
    cover_url = arr.nil? || arr.empty? ? cover_placeholder : arr.first['url']

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

  private


  def set_cover_url(arr)
    cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"
    arr.nil? || arr.empty? ? cover_placeholder : arr.first['url']
  end
end
