class User < ApplicationRecord
  has_one :spotify_token
  has_many :playlists
  has_many :tracks
  has_many :sptags

  # validate :spotify_client_must_exist

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def email_required?
    false
  end

  def add_tags(arr)
    arr.each do |tag|
      sptag = Sptag.where(name: tag).take
      Sptag.create(name: tag, user: self) unless sptag
    end
  end

  def remove_tags(arr) # pablior
  end

  def add_spotify_data(sp_data)
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
    return unless spotify_token

    spotify_token.expires_at >= Time.now
  end

  def token
    return unless spotify_token

    "Authorization: Bearer #{spotify_token.code}"
  end

  def email_changed?
    false
  end

  validates :username, presence: true, uniqueness: true

  private

  # def fetch_spotify_data
  #   rsp_user = RSpotify::User.find(spotify_client)
  #   rsp_user.playlists.each do |playlist|
  #     create_playlist(playlist)
  #     playlist.tracks.each { |t| create_track(t) }
  #   end
  # end

  # def create_playlist(playlist)
  #   cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"
  #   url = playlist.id
  #   name = playlist.name
  #   cover_url = playlist.images.empty? ? cover_placeholder : playlist.images.first['url']

  #   Playlist.create(user: self, url: url, cover_url: cover_url)
  # end

  # def create_track(track)
  #   name = track.name
  #   artist = track.artists.first.name
  #   url = track.id
  #   cover_url = track.album.images.first['url']

  #   Track.create(user: self, url: url, cover_url: cover_url, artist: artist)
  # end

  # def spotify_client_must_exist
  #   begin
  #     user = RSpotify::User.find(spotify_client)
  #   rescue
  #     errors.add(:spotify_client, 'this username does not exist')
  #   end
  # end
end
