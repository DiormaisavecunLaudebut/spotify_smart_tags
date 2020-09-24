class UserTracksController < ApplicationController
  before_action :user_track_info, only: %i[show_tags modal]

  def show_tags
    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def modal
    @name = @track.name
    @artist = @track.artist
    @href = @track.external_url
    @cover = @track.cover_url

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def filter
    @tags = params['filter-tags']
    tag_list = @tags.split('$$')
    track_scope = current_user.filter_all ? UserTrack.all : current_user.user_tracks

    user_tracks = track_scope.select do |user_track|
      user_track.tagged_with(tag_list)
    end

    tracks_object = user_tracks.map(&:track)
    @tracks = user_tracks.map { |i| helpers.serialize_track_info(i, @tag_name) }.join('$$')
    @uris = tracks_object.map { |i| "spotify:track:#{i.spotify_id}" }.join('$$')

    @untagged_tracks = current_user.user_tracks.where(is_tag: false).count

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  private

  def user_track_info
    @id = params['user_track_id']
    @user_track = UserTrack.find(@id)
    @tags = @user_track.tag_list.join('$$')
    @track = @user_track.track
  end
end
