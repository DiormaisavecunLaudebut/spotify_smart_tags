class TagsController < ApplicationController

  def add_tag
    @id = params['track_id']
    track = Track.find(@id)
    @tag = params['tag']
    @notification = track.is_tag

    @challenge_completed = update_challenge(1)

    track.add_tag(@tag, current_user) # pablior check (wtf)
    current_user.add_tag(@tag) # this line might be useless, to check late

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def remove_tag
    @id = params['track_id']
    track = Track.find(@id)
    @tag = params['tag']

    track.remove_tag(@tag, current_user)

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def tags_suggestions
    @id = params['track_id']
    track = Track.find(@id)
    tags = track.get_suggestions
    @suggestions = tags.nil? ? "" : tags.reject { |i| track.tag_list.include?(i.downcase.capitalize) }.sample(4).join('$$')

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def bulk_add_tags
    @ids = params['track-ids'].split(',').join('$$')
    tags = params['tags'].split(',')
    tracks = params['track-ids'].split(',').map { |i| Track.find(i) }

    @points = tracks.select { |i| i.is_tag == false }.count * 10
    @challenge_completed = update_challenge(tracks.count)

    tracks.each do |track|
      track.add_tags(tags, current_user)
      current_user.add_tags(tags)
    end

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  private

  def update_challenge(count)
    challenge = current_user.daily_challenges.last
    score = challenge.tracks_tagged
    challenge.update!(tracks_tagged: score + count)

    if challenge.tracks_tagged >= 10
      challenge.update!(completed: true)
      true
    else
      false
    end
  end

end


