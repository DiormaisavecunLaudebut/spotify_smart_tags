class PlaylistsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :add_tag

  def index
    @user_tags = Tag.all
    @playlists = Playlist.sort_by_user_preference(current_user)
  end

  def show
    @points = params['points']
    track_tagged_count = @points.to_i / 10
    @id = params['id']
    @playlist = Playlist.find(@id)

    manage_achievements(@points.to_i, track_tagged_count) if @points

    @user_tracks = @playlist.user_tracks
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
end
