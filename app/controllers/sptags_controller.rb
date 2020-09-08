class SptagsController < ApplicationController
  def index
    @sptags = current_user.sptags.map { |sptag| [sptag.name, sptag.track_count] }.sort_by(&:last).reverse
    @untagged_tracks_count = current_user.tracks.where(is_tag: false).count
    @user_tags = current_user.sptags.map(&:name).join(' ')
  end

  def show_tracks
    @tag_name = params['sptag_id'].match(/(.*)\//)[1]
    tracks_object = current_user.tracks_tagged_with(@tag_name)
    @tracks = tracks_object.map { |i| track_info(i, @tag_name) }.join('$$')

    respond_to do |format|
      format.html { redirect_to sptags_path }
      format.js
    end
  end

  def show_untagged_tracks
    tracks_object = current_user.tracks.where(is_tag: false)
    @tracks = tracks_object.map { |i| track_info(i, @tag_name) }.join('$$')

    respond_to do |format|
      format.html { redirect_to sptags_path }
      format.js
    end
  end
end
