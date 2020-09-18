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

  def index
    @playlists = current_user.playlists
    @user_tags = current_user.sptags.map(&:name).join(' ')
  end

  def create_spotify_playlist
    path = "https://api.spotify.com/v1/users/#{current_user.spotify_client}/playlists"
    content_type = 'application/json'
    uris = params['track-uris'].split('$$')
    self_destroy = params['Self-destroy']

    resp = SpotifyApiCall.post(
      path,
      current_user.token,
      helpers.create_playlist_body(params),
      content_type
    )

    playlist = Playlist.create_playlist(resp, current_user)
    TracklandPlaylist.create_playlist(current_user, params, playlist)
    UpdateCoverUrlJob.perform_later(playlist.id, current_user.id)

    DestroyPlaylistJob.set(wait: 24.hours).perform_later(current_user.id, playlist.id) if self_destroy == 'on'

    fill_playlist_with_tracks(playlist, uris)

    @playlist_url = playlist.external_url

    # pablior
    # create a job to set the cover_url
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
