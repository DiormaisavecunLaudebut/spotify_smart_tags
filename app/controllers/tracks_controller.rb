class TracksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[add_tag remove_tag]

  def filter_tracks
    @tags = params['filter-tags']
    tracks_object = current_user.filter_all ? Track.tagged_with(@tags.split('$$')) : current_user.tracks_tagged_with(@tags.split('$$'))
    @tracks = tracks_object.map { |i| helpers.serialize_track_info(i, @tag_name) }.join('$$')
    @uris = tracks_object.map { |i| "spotify:track:#{i.spotify_id}" }.join('$$')

    @untagged_tracks = current_user.user_tracks.where(is_tag: false).count

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end

  def search_tracks
    key = "%#{params['query'].strip.downcase}%"
    columns = %w[name artist]

    @tracks = current_user.tracks.where(
      columns
        .map { |c| "lower(#{c}) like :search" }
        .join(' OR '),
      search: key
    ).first(20).map { |i| [i.user_tracks.where(user: current_user).take.id, i.name, i.artist, i.cover_url].join('**') }.join('$$')

    respond_to do |format|
      format.html { redirect_to playlists_path }
      format.js
    end
  end
end
