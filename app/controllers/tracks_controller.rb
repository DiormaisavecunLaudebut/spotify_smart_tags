class TracksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[add_tags_to_track]

  def add_tags_to_track
    track = Track.find(params['track_id'])
    tags = params['tags'].split(',')

    track.add_tags(tags, current_user)
    current_user.add_tags(tags) # this line might be useless, to check late
  end

  def remove_tags_to_track
    tags = %w[test1 test2 test3]
    current_user.remove_tags(tags)
  end

  def filter_tracks
    raise
  end

  def create_tag; end
end
