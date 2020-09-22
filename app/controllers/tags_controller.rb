class TagsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :add_tag

  def add_tag
    @id = params['track_id']
    track = Track.find(@id)
    @tag = helpers.standardize_tags(params['tag'])
    @notification = track.is_tag

    manage_achievements([track])

    track.add_tag(@tag, current_user)

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def remove_tag
    @id = params['track_id']
    track = Track.find(@id)
    @tag = helpers.standardize_tags(params['tag'])

    track.remove_tag(@tag, current_user)

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def tags_suggestions
    @id = params['track_id']
    track = Track.find(@id)
    tags = helpers.standardize_tags(track.get_suggestions)
    @suggestions = tags.nil? ? "" : tags.reject { |i| track.tag_list.include?(i.downcase) }.sample(4).join('$$')
    @user_tags = current_user.sptags.map(&:name).reject { |i| track.tag_list.include?(i) }.join('$$')
    @used_tags = track.tag_list.join('$$')

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def bulk_add_tags
    @ids = params['track-ids'].split(',').join('$$')
    tags = helpers.standardize_tags(params['tags'].split('$$'))
    tracks = params['track-ids'].split(',').map { |i| Track.find(i) }

    manage_achievements(tracks)

    tracks.each { |track| track.add_tags(tags, current_user) }

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end
end
