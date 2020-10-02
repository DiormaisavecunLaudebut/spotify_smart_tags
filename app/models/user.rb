class User < ApplicationRecord
  has_one :spotify_token
  has_many :playlists, dependent: :destroy
  has_many :data_updates
  has_many :trackland_playlists
  has_many :spotify_api_calls
  has_many :daily_challenges

  has_many :user_tracks
  has_many :tracks, through: :user_tracks
  has_many :user_track_tags, through: :user_tracks

  has_many :user_tags
  has_many :tags, through: :user_tags

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :username, presence: true, uniqueness: true
  validates :email, uniqueness: false

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

  def status_changed?(exp)
    update_status(exp)
    points + exp >= get_permissions[:max_points]
  end

  def add_points(value)
    update!(points: points + value)
    update_status(points)
  end

  def update_status(points)
    if points >= 1000
      status = 'music geek'
    elsif points >= 200
      status = 'pro'
    else
      status = nil
    end
    update!(status: status) if status
    status
  end

  def switch_lang
    lang = locale == 'fr' ? 'en' : 'fr'
    update(locale: lang)
  end

  def last_update(source)
    DataUpdate.where(user: self, source: source).last&.created_at&.to_date&.all_day
  end

  def last_challenge
    DailyChallenge.where(user: self).last&.created_at&.to_date&.all_day
  end

  def fetch_spotify_data
    DataUpdate.create(user: self, source: 'spotify')

    update_user_data
    update_playlist_and_tracks if spotify_update_follow_playlists || spotify_update_my_playlists
    update_user_albums if spotify_update_albums
    update_user_liked_songs if spotify_update_liked_songs
  end

  def add_fetched_data(sp_data)
    update!(
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

  # ---------------------------------------- ALBUMS ---------------------------------------------------

  def update_user_albums
    my_albums = all_albums

    delete_album_difference(my_albums)
    update_or_create_albums(my_albums)
  end

  def update_or_create_albums(my_albums)
    my_albums.each do |sp|
      playlist = Playlist.find_or_create_album(sp['album'], self)

      create_album_tracks(playlist, sp['album'])
    end
  end

  def all_albums(offset = 0, my_albums = [])
    resp = SpotifyApiCall.get_albums(token, offset)

    resp['items'].each { |i| my_albums << i }

    offset = ApplicationController.helpers.new_offset(offset, 50, resp['total'])
    all_albums(offset, my_albums) if offset

    my_albums
  end

  def delete_album_difference(my_albums)
    album_ids = Playlist.where(playlist_type: 'album', user: self).map(&:id)

    my_albums.each { |alb| album_ids.delete(alb['album']['id']) }

    delete_remaining_playlists(album_ids)
  end

  #------------------------------ PLAYLISTS ----------------------------------------------

  def update_playlist_and_tracks
    my_playlists = all_playlists

    delete_playlist_difference(my_playlists)
    update_or_create_playlists(my_playlists)
  end

  def all_playlists(offset = 0, all_playlists = [])
    resp = SpotifyApiCall.get_playlists(token, offset)

    playlists = select_playlist_according_to_user_preferences(resp)
    playlists.each { |i| all_playlists << i }

    offset = ApplicationController.helpers.new_offset(offset, 50, resp['total'])
    all_playlists(offset, all_playlists) if offset

    all_playlists
  end

  def delete_playlist_difference(my_playlists)
    playlist_ids = playlists.where(playlist_type: 'playlist').map(&:id)

    my_playlists.each { |sp| playlist_ids.delete(sp['id']) }

    delete_remaining_playlists(playlist_ids)
  end

  def update_or_create_playlists(playlists)
    playlists.each do |sp|
      playlist = Playlist.find_or_create(sp, self)
      fetch_playlist_tracks(playlist) if playlist.track_count != sp['tracks']['total']
    end
  end

  def delete_remaining_playlists(playlists)
    playlists.map { |i| Playlist.find(i) }.each do |playlist|
      playlist.user_playlist_tracks.each(&:destroy)
      playlist.destroy
    end
  end

  # ---------------------------------- TRACKS -----------------------------------------

  def fetch_playlist_tracks(playlist)
    my_tracks = all_tracks(playlist.spotify_id)
    delete_track_difference(playlist, my_tracks)
    create_tracks(playlist, my_tracks)
  end

  def all_tracks(playlist_id, all_tracks = [], offset = 0)
    resp = SpotifyApiCall.get_playlist_tracks(token, playlist_id, offset)

    resp['items'].each { |i| all_tracks << i }

    offset = ApplicationController.helpers.new_offset(offset, 100, resp['total'])
    all_tracks(playlist_id, all_tracks, offset) if offset

    all_tracks
  end

  def delete_track_difference(playlist, my_tracks)
    ids = playlist.user_playlist_tracks.map(&:id)

    my_tracks.each { |tr| ids.delete(tr['id']) }

    delete_remaining_user_playlist_tracks(ids)
  end

  def create_tracks(playlist, my_tracks)
    my_tracks.each do |tr|
      track = Track.find_or_create(tr['track'])
      user_track = UserTrack.find_or_create(self, track)
      UserPlaylistTrack.find_or_create(playlist, user_track)
    end
  end

  def create_album_tracks(playlist, my_tracks)
    cover = my_tracks['images']
    my_tracks['tracks']['items'].each do |tr|
      track = Track.find_or_create(tr, cover)
      user_track = UserTrack.find_or_create(self, track)
      UserPlaylistTrack.find_or_create(playlist, user_track)
    end
  end

  # -------------------------------- LIKED SONGS -----------------------------------------

  def all_liked_tracks(all_tracks = [], offset = 0)
    resp = SpotifyApiCall.get_liked_songs(token, offset)

    resp['items'].each { |i| all_tracks << i }

    offset = ApplicationController.helpers.new_offset(offset, 50, resp['total'])
    all_liked_tracks(all_tracks, offset) if offset

    all_tracks
  end

  def update_user_liked_songs
    playlist = Playlist.find_or_create_likes(self)

    my_tracks = all_liked_tracks
    delete_track_difference(playlist, my_tracks)
    create_tracks(playlist, my_tracks)
  end

  # --------------------------------------------------------------------------------------

  def fetch_spotify_tracks_metadata(tracks)
    ids = tracks.map(&:spotify_id)
    path = 'https://api.spotify.com/v1/audio-features'
    resp = SpotifyApiCall.get(path, token, { ids: ids.join(',') })
    return if resp['audio_features'][0].nil?

    resp['audio_features'].each do |result|
      track = Track.where(spotify_id: result['id']).take

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

  def delete_remaining_user_playlist_tracks(user_playlist_track_ids)
    user_playlist_track_ids.each { |id| UserPlaylistTrack.find(id).destroy }
  end

  def self.to_csv
    headers = %w[username email filter_all user_track_count user_track_tagged_count user_tag_count playlist_count user_playlist_track_count trackland_playlist_count]

    CSV.generate(headers: true) do |csv|
      csv << headers

      all.each do |user|
        username = user.username
        email = user.email
        filter_all = user.filter_all
        user_track_count = user.user_tracks.count
        user_track_tagged_count = user.user_tracks.select(&:is_tag).count
        user_tag_count = user.user_tags.count
        playlist_count = user.playlists.count
        user_playlist_track_count = user.playlists.map { |i| i.user_playlist_tracks.count }.reduce(&:+)
        trackland_playlist_count = user.trackland_playlists.count

        csv << [username, email, filter_all, user_track_count, user_track_tagged_count, user_tag_count, playlist_count, user_playlist_track_count, trackland_playlist_count]
      end
    end
  end

  def select_playlist_according_to_user_preferences(resp)
    if spotify_update_follow_playlists && spotify_update_my_playlists
      resp['items']
    elsif spotify_update_follow_playlists && !spotify_update_my_playlists
      resp['items'].reject { |i| i['owner']['id'] == spotify_client }
    elsif !spotify_update_follow_playlists && spotify_update_my_playlists
      resp['items'].select { |i| i['owner']['id'] == spotify_client }
    end
  end
end
