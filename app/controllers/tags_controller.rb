class TagsController < ApplicationController
  def select_tag
    tag = params['tag_name']
    tags = current_user.request_tags
    tags.include?(tag) ? tags.delete(tag) : tags.push(tag)
    current_user.update!(request_tags: tags)

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def bulk_add_tags
    @ids = params['track-ids'].split(',').join('$$')
    tags = params['tags'].split(',')
    tracks = params['track-ids'].split(',').map { |i| Track.find(i) }
    tracks.each do |track|
      track.add_tags(tags, current_user)
      current_user.add_tags(tags)
    end

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end
end
