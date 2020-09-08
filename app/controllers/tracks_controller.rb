class TracksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[add_tags_to_track]

  def add_tags_to_track
    track = Track.find(params['track_id'])
    tags = params['tags'].split(',')

    track.add_tags(tags, current_user)
    current_user.add_tags(tags) # this line might be useless, to check late
  end

  def remove_tags_to_track
  end

  def filter_tracks
    @tags = params['q']
    tracks_object = current_user.tracks_tagged_with(@tags.split(','))
    @tracks = tracks_object.map { |i| track_info(i, @tag_name) }.join('$$')
    @uris = tracks_object.map { |i| "spotify:track:#{i.spotify_id}" }.join('$$')

    @untagged_tracks = current_user.tracks.where(is_tag: false).count

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def create_tag; end
end
