class SptagsController < ApplicationController
  def index
    @sptags = current_user.sptags.map { |sptag| [sptag.name, sptag.track_count] }.sort_by(&:last).reverse
    @user_tags = current_user.sptags.map(&:name).join(' ')
  end

  def show_tracks
    @tag_name = params['sptag_id'].match(/(.*)\//)[1]

    tracks_object = current_user.tracks.select { |i| i.tag_list.include?(@tag_name) }
    @tracks = tracks_object.map { |i| track_info(i, @tag_name) }.join('$$')

    respond_to do |format|
      format.html { redirect_to sptags_path }
      format.js
    end
  end

  private

  def track_info(track, tag_name)
    tags = track.tag_list
    tags.delete(tag_name)
    [
      track.name,
      track.artist,
      track.cover_url,
      track.external_url,
      track.id,
      tags
    ].join('**')
  end
end
