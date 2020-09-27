class PlaylistsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :add_tag
  before_action :refresh_user_token!, only: :create_spotify_playlist

  def index
    @playlists = current_user.playlists
    @user_tags = Tag.all
  end

  def show
    @points = params['points']
    track_tagged_count = @points.to_i / 10
    @id = params['id']
    playlist = Playlist.find(@id)

    manage_achievements(@points.to_i, track_tagged_count) if @points

    @user_tracks = playlist.user_tracks
    @user_tags = Tag.all.map(&:name)
    @used_tags = current_user.tags.sort_by(&:track_count).map(&:name).reverse.first(6)
    @modal_tags = current_user.tags.first(6).map(&:name)
  end

  def modal
    @id = params['playlist_id']
    playlist = Playlist.find(@id)
    hash = {}

    playlist.user_tracks.each do |user_track|
      user_track.tag_list.each do |tag|
        hash[tag].nil? ? hash[tag] = 1 : hash[tag] += 1
      end
    end

    @tags = hash.to_a

    @name = playlist.name
    @href = playlist.external_url
    @cover = playlist.cover_url
    @description = playlist.description
    @user_tags = Tag.all.map(&:name)
    @used_tags = []
  end

  def add_tag
    playlist = Playlist.find(params['playlist_id'])
    @tag = params['tag']
    user_tracks = playlist.user_tracks
    @count = user_tracks.count

    untagged_tracks = user_tracks.reject(&:is_tag).count
    @points = untagged_tracks * 10

    manage_achievements(@points, untagged_tracks)

    user_tracks.each { |user_track| user_track.add_tags(@tag, current_user) }

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def create_spotify_playlist
    path = "https://api.spotify.com/v1/users/#{current_user.spotify_client}/playlists"
    content_type = 'application/json'

    max_tracks = current_user.get_permissions[:max_tracks]
    self_destroy = params['Self-destroy']

    uris = params['track-uris'].split('$$').map { |i| "spotify:track:#{i}" }

    uris = uris.sample(max_tracks) unless max_tracks == 'unlimited'

    resp = SpotifyApiCall.post(
      path,
      current_user.token,
      helpers.create_playlist_body(params),
      content_type
    )

    playlist = Playlist.create_playlist(resp, current_user)
    TracklandPlaylist.create_playlist(current_user, params, playlist)
    UpdateCoverUrlJob.set(wait: 2.minutes).perform_later(playlist.id, current_user.id)

    DestroyPlaylistJob.set(wait: 24.hours).perform_later(current_user.id, playlist.id) if self_destroy

    fill_playlist_with_tracks(playlist, uris)

    @playlist_url = playlist.external_url
  end

  private

  def fill_playlist_with_tracks(playlist, uris)
    path = "https://api.spotify.com/v1/playlists/#{playlist.spotify_id}/tracks"
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

    tracks = spotify_ids.map { |id| Track.where(spotify_id: id).take }

    tracks.each do |track|
      user_track = UserTrack.create(user: current_user, track: track)
      UserPlaylistTrack.create(playlist: playlist, user_track: user_track)
    end

    fill_playlist_with_tracks(playlist, uris) unless uris.empty?
  end
end
