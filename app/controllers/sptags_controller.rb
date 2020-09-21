class SptagsController < ApplicationController
  def index
    @sptags = current_user.sptags.map { |sptag| [sptag.name, sptag.track_count] }.sort_by(&:last).reverse
    @used_tags = @sptags.first(6).map(&:first).join('$$')
    @untagged_tracks_count = current_user.tracks.where(is_tag: false).count
    @user_tags = current_user.sptags.map(&:name).join('$$')
  end

  def show_tracks
    tags = {}
    @tag_name = params['sptag_id'].match(/(.*)\//)[1]
    tracks_object = current_user.tracks_tagged_with(@tag_name)
    @tracks = tracks_object.map { |i| helpers.serialize_track_info(i) }.join('$$')

    tracks_object.each do |track|
      track.tag_list.each do |tag|
        tags[tag].nil? ? tags[tag] = 1 : tags[tag] += 1
      end
    end

    @subtags = tags.to_a.sort_by(&:last).reverse.map { |i| i.join('**') }.join('$$')

    respond_to do |format|
      format.html { redirect_to sptags_path }
      format.js
    end
  end

  def show_untagged_tracks
    tracks_object = current_user.tracks.where(is_tag: false)
    @tracks = tracks_object.map { |i| helpers.serialize_track_info(i, @tag_name) }.join('$$')

    respond_to do |format|
      format.html { redirect_to sptags_path }
      format.js
    end
  end
end
