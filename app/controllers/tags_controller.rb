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
end
