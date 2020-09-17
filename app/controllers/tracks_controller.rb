class TracksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[add_tag remove_tag]

  def add_tag
    @id = params['track_id']
    track = Track.find(@id)
    @tag = params['tag']

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

  def show_modal
    @id = params['track_id']
    track = Track.find(@id)

    @name = track.name
    @artist = track.artist
    @href = track.external_url
    @cover = track.cover_url
    @tags = track.tag_list.join('$$')

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def show_tags
    @id = params['track_id']
    track = Track.find(@id)
    @tags = track.tag_list.join('$$')

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def filter_tracks
    @tags = params['filter-tags']
    tracks_object = current_user.filter_all ? Track.tagged_with(@tags.split(',')) : current_user.tracks_tagged_with(@tags.split(','))
    @tracks = tracks_object.map { |i| helpers.serialize_track_info(i, @tag_name) }.join('$$')
    @uris = tracks_object.map { |i| "spotify:track:#{i.spotify_id}" }.join('$$')

    @untagged_tracks = current_user.tracks.where(is_tag: false).count

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def create_tag; end
end
