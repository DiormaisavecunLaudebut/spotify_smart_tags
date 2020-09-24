class TagsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[add_tag remove_tag]

  def add_tag
    @id = params['user_track_id']
    user_track = UserTrack.find(@id)
    @tag = helpers.standardize_tags(params['tag'])

    manage_achievements([user_track])

    user_track.add_tags(@tag, current_user)

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def show
    tags = {}
    @tag_name = params['id'].match(/(.*)\//)[1]
    track_scope = current_user.filter_all ? UserTrack.all : current_user.user_tracks

    user_tracks_object = track_scope.select do |user_track|
      user_track.tagged_with(@tag_name)
    end

    @tracks = user_tracks_object.map { |i| helpers.serialize_track_info(i) }.join('$$')

    user_tracks_object.each do |user_track|
      user_track.tag_list.each do |tag|
        tags[tag].nil? ? tags[tag] = 1 : tags[tag] += 1
      end
    end

    @subtags = tags.to_a.sort_by(&:last).reverse[1..-1].map { |i| i.join('**') }.join('$$')

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def remove_tag
    @id = params['user_track_id']
    user_track = UserTrack.find(@id)
    @tag = helpers.standardize_tags(params['tag'])

    user_track.remove_tags(@tag, current_user)

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def tags_suggestions
    @id = params['track_id']
    track = Track.find(@id)
    tags = helpers.standardize_tags(track.get_suggestions)
    user_track = track.user_tracks.where(track: track, user: current_user).take

    @suggestions = tags.nil? ? "" : tags.reject { |i| user_track.tag_list.include?(i.downcase) }.sample(4).join('$$')
    @user_tags = current_user.tags.map(&:name).reject { |i| user_track.tag_list.include?(i) }.join('$$')
    @used_tags = user_track.tag_list.join('$$')

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def bulk_add_tags
    @ids = params['user-track-ids'].split(',').join('$$')
    tags = helpers.standardize_tags(params['tags'].split('$$'))
    user_tracks = params['user-track-ids'].split(',').map { |i| UserTrack.find(i) }

    manage_achievements(user_tracks)

    user_tracks.each { |user_track| user_track.add_tags(tags, current_user) }

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end
end

