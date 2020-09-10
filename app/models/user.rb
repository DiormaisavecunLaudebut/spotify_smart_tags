class User < ApplicationRecord
  has_one :spotify_token
  has_many :playlists, dependent: :destroy
  has_many :tracks
  has_many :sptags, dependent: :destroy
  has_many :data_updates
  has_many :trackland_playlists
  has_many :spotify_api_calls

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true

  def email_required?
    false
  end

  def switch_lang
    lang = locale == 'fr' ? 'en' : 'fr'
    update(locale: lang)
  end

  def last_update(source)
    DataUpdate.where(user: self, source: source).last.created_at.to_date.all_day
  end

  def fetch_spotify_data
    update_user_data
    update_user_playlists_and_tracks
  end

  def add_tags(arr)
    arr.each do |tag|
      sptag = Sptag.where(name: tag).take
      Sptag.create(name: tag, user: self) unless sptag
    end
  end

  def tracks_tagged_with(tags)
    Track.tagged_with(tags).where(user: self)
  end

  def add_fetched_data(sp_data)
    update(
      country: sp_data['country'],
      spotify_client: sp_data['id'],
      email: sp_data['email'],
      external_url: sp_data['external_urls']['spotify'],
      display_name: sp_data['display_name'],
      product: sp_data['display_name'],
      followers: sp_data['followers']['total']
    )
  end

  def valid_token?
    return if spotify_token.nil?

    spotify_token.expires_at >= Time.now
  end

  def token
    return unless spotify_token

    "Authorization: Bearer #{spotify_token.code}"
  end

  def email_changed?
    false
  end

  def update_user_data
    path = 'https://api.spotify.com/v1/me'

    resp = SpotifyApiCall.get(path, token)
    add_fetched_data(resp)
  end

  def update_user_playlists_and_tracks(offset = 0, my_playlists = playlists.map(&:id))
    puts "in update_user_playlists_and_tracks"
    path = 'https://api.spotify.com/v1/me/playlists'
    limit = 50
    options = { limit: limit, offset: offset }

    resp = SpotifyApiCall.get(path, token, options)
    puts resp
    playlists = resp['items'].select { |i| i['owner']['id'] == spotify_client }

    playlists.each do |sp|
      playlist = Playlist.find_playlist(sp['id'], self)
      if playlist
        my_playlists.delete(playlist.id)
      else
        playlist = Playlist.create_playlist(sp, self)
      end
      fetch_playlist_tracks(playlist) if playlist.track_count != sp['tracks']['total']
    end

    offset = ApplicationController.helpers.new_offset(offset, limit, resp['total'])
    offset ? update_user_playlists_and_tracks(offset, my_playlists) : delete_remaining_playlists(my_playlists)
  end

  def fetch_playlist_tracks(playlist, offset = 0, my_tracks = [])
    path = "https://api.spotify.com/v1/playlists/#{playlist.spotify_id}/tracks"
    my_tracks = playlist.tracks.map(&:id) if my_tracks.empty?
    limit = 100
    options = { limit: limit, offset: offset }

    resp = SpotifyApiCall.get(path, token, options)
    tracks = resp['items']

    tracks.each do |tr|
      track = Track.find_track(tr['track']['id'], self)
      if track
        my_tracks.delete(track.id)
      else
        track = Track.create_track(tr['track'], self)
        PlaylistTrack.create_plt(playlist, track)
      end
    end

    offset = ApplicationController.helpers.new_offset(offset, limit, resp['total'])
    fetch_playlist_tracks(playlist, offset, my_tracks) if offset

    delete_remaining_tracks(my_tracks)
  end

  def delete_remaining_tracks(tracks)
    tracks.map { |i| Track.find(i) }.each(&:destroy)
  end

  def delete_remaining_playlists(playlists)
    playlists.map { |i| Playlist.find(i) }.each do |playlist|
      playlist.destroy
      playlist.tracks.each { |track| track.destroy if track.playlist_tracks.empty? }
    end
  end
end
