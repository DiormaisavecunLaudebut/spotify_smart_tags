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

  def get_permissions
    case status
    when 'amateur' then ApplicationController.helpers.amateur_permissions
    when 'pro' then ApplicationController.helpers.pro_permissions
    when 'music geek' then ApplicationController.helpers.music_geek_permission
    end
  end

  def switch_lang
    lang = locale == 'fr' ? 'en' : 'fr'
    update(locale: lang)
  end

  def last_update(source)
    DataUpdate.where(user: self, source: source).last&.created_at&.to_date&.all_day
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
    path = 'https://api.spotify.com/v1/me/playlists'
    limit = 50
    options = { limit: limit, offset: offset }

    resp = SpotifyApiCall.get(path, token, options)

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
    new_tracks = []

    tracks.each do |tr|
      track = Track.find_track(tr['track']['id'], self)
      if track
        my_tracks.delete(track.id)
      else
        new_tracks << Track.create_track(tr['track'], self)
        PlaylistTrack.create_plt(playlist, new_tracks.last)
      end
    end

    fetch_spotify_tracks_metadata(new_tracks)

    offset = ApplicationController.helpers.new_offset(offset, limit, resp['total'])
    fetch_playlist_tracks(playlist, offset, my_tracks) if offset

    delete_remaining_tracks(my_tracks)
  end

  def fetch_spotify_tracks_metadata(tracks)
    ids = tracks.map(&:spotify_id)
    path = 'https://api.spotify.com/v1/audio-features'
    resp = SpotifyApiCall.get(path, token, { ids: ids.join(',') })

    resp['audio_features'].each do |result|
      track = Track.where(user: self, spotify_id: result['id']).take

      evaluate_danceability(track, result['danceability'])
      evaluate_instrumentalness(track, result['instrumentalness'])
      evaluate_valence(track, result['valence'])
      evaluate_acousticness(track, result['acousticness'])
      track.save
    end
  end

  def evaluate_danceability(track, value)
    # Danceability describes how suitable a track is for dancing based on a combination
    # of musical elements including tempo, rhythm stability, beat strength, and overall
    # regularity. A value of 0.0 is least danceable and 1.0 is most danceable.

    track.spotify_tags << 'dance' if value >= 0.82
  end

  def evaluate_instrumentalness(track, value)
    # Predicts whether a track contains no vocals. 'Ooh' and 'aah' sounds are
    # treated as instrumental in this context. Rap or spoken word tracks are
    # clearly 'vocal'. The closer the instrumentalness value is to 1.0, the greater
    # likelihood the track contains no vocal content. Values above 0.5 are intended
    # to represent instrumental tracks, but confidence is higher as the value approaches 1.0.

    track.spotify_tags << 'vocal' if value <= 0.01
    track.spotify_tags << 'instrumental' if value >= 0.8
  end

  def evaluate_valence(track, value)
    # A measure from 0.0 to 1.0 describing the musical positiveness conveyed by
    # a track. Tracks with high valence sound more positive (e.g. happy, cheerful, euphoric),
    # while tracks with low valence sound more negative (e.g. sad, depressed, angry).

    track.spotify_tags << %w[sad depressed angry].sample if value <= 0.25
    track.spotify_tags << %w[happy cheerful euphoric].sample if value >= 0.75
  end

  def evaluate_acousticness(track, value)
    # A confidence measure from 0.0 to 1.0 of whether the track is acoustic.
    # 1.0 represents high confidence the track is acoustic.

    track.spotify_tags << 'acoustic' if value >= 0.75
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
