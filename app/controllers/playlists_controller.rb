class PlaylistsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :refresh_user_token!, only: :create_spotify_playlist

  def show
    playlist = Playlist.find(params['id'])
    @tracks = playlist.tracks
    @user_tags = current_user.sptags.map(&:name).join(' ')

    @sptags = current_user.sptags.map { |sptag| [sptag.name, sptag.track_count] }.sort_by(&:last).reverse
    @modal_tags = @sptags.first(6).map(&:first)
  end

  def show_playlist_actions
    @id = params['playlist_id']
    playlist = Playlist.find(@id)
    hash = {}

    playlist.tracks.each do |track|
      track.tag_list.each do |tag|
        hash[tag].nil? ? hash[tag] = 1 : hash[tag] += 1
      end
    end

    @tags = hash.to_a.map { |i| i.join('**') }.join('$$')

    @name = playlist.name
    @href = playlist.external_url
    @cover = playlist.cover_url
    @description = playlist.description

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def add_tag
    playlist = Playlist.find(params['playlist_id'])
    tracks = playlist.tracks
    @tag = params['tag']
    @count = tracks.count

    @points = playlist.tracks.select { |i| i.is_tag == false }.count * 10
    @status_changed = current_user.status_changed?(@points)
    @challenge_completed = update_challenge(tracks.count)
    current_user.add_points(@points)
    @status = current_user.status

    playlist.tracks.each { |track| track.add_tag(@tag, current_user) }

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def index
    @playlists = current_user.playlists
    @user_tags = current_user.sptags.map(&:name).join(' ')
  end

  def create_spotify_playlist
    path = "https://api.spotify.com/v1/users/#{current_user.spotify_client}/playlists"
    content_type = 'application/json'
    max_tracks = current_user.get_permissions[:max_tracks]

    if max_tracks == 'unlimited'
      uris = params['track-uris'].split('$$')
    else
      uris = params['track-uris'].split('$$').sample(max_tracks)
    end

    self_destroy = params['Self-destroy']

    resp = SpotifyApiCall.post(
      path,
      current_user.token,
      helpers.create_playlist_body(params),
      content_type
    )

    playlist = Playlist.create_playlist(resp, current_user)
    TracklandPlaylist.create_playlist(current_user, params, playlist)
    UpdateCoverUrlJob.set(wait: 2.minutes).perform_later(playlist.id, current_user.id)

    DestroyPlaylistJob.set(wait: 24.hours).perform_later(current_user.id, playlist.id) if self_destroy == 'on'

    fill_playlist_with_tracks(playlist, uris)

    @playlist_url = playlist.external_url
  end

  private

  def fill_playlist_with_tracks(playlist, uris)
    playlist_id = playlist.spotify_id
    path = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks"
    content_type = 'application/json'
    spotify_ids = uris.map { |i| i.gsub('spotify:track:', '') }
    limit = 100
    sp_uris = uris.shift(limit)

    SpotifyApiCall.post(
      path,
      current_user.token,
      { uris: sp_uris },
      content_type
    )

    tracks = spotify_ids.map { |i| Track.where(user: current_user, spotify_id: i).take }
    tracks.each { |track| PlaylistTrack.create_plt(playlist, track) }

    fill_playlist_with_tracks(playlist, uris) unless uris.empty?
  end
end
