class UserTracksController < ApplicationController
  before_action :user_track_info, only: %i[show_tags modal]

  def show_tags
    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def show
    @id = params['id']
    user_track = UserTrack.find(@id)
    track = user_track.track

    @track_id = track.spotify_id
    @cover_url = track.cover_url
    @name = track.name
    @artist = track.artist
    @tags = user_track.tags
    @href = track.external_url
    @user_tags = current_user.tags.map(&:name)
    @used_tags = user_track.tag_list
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
    @tags = params['tags']
    tag_list = @tags.split('$$')
    tag_objects = tag_list.map { |i| Tag.where(name: i).take }
    user_track_tags = UserTrackTag.where(tag: tag_objects.first)

    if current_user.filter_all
      user_tracks = user_track_tags.map(&:user_track)
    else
      user_tracks = user_track_tags.map(&:user_track).select { |i| i.user == current_user }
    end

    user_tracks = user_tracks.select { |i| i.tagged_with(tag_list) }

    tracks_object = user_tracks.map(&:track)
    @tracks = user_tracks.map { |i| helpers.serialize_track_info(i, @tag_name) }.join('$$')
    @track_ids = user_tracks.map { |i| i.track.id }.join('$$')

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
