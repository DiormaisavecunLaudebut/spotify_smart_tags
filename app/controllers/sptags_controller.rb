class SptagsController < ApplicationController
  def index
    @points = params['points']
    track_tagged_count = @points.to_i / 10
    manage_achievements(@points.to_i, track_tagged_count) if @points

    @tags = Tag.sort_by_user_preference(current_user).map { |i| [i.tag.name, i.tag.created_at, i.tag.id, i.track_count] }

    @used_tags = @tags.first(6).map(&:first)
    @untagged_tracks_count = current_user.user_tracks.where(is_tag: false).count
    @user_tags = Tag.all.map(&:name)
  end

  def show_tracks
    tags = {}
    @tag_name = params['sptag_id'].match(/(.*)\//)[1]
    tracks_object = current_user.tracks
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
    user_tracks_object = current_user.user_tracks.where(is_tag: false)

    @tracks = user_tracks_object.map { |user_track| helpers.serialize_track_info(user_track, @tag_name) }.join('$$')

    respond_to do |format|
      format.html { redirect_to sptags_path }
      format.js
    end
  end
end
