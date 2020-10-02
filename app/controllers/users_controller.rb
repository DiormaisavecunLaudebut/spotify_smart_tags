require 'csv'

class UsersController < ApplicationController
  def filter_all_option
    option = !current_user.filter_all
    current_user.update!(filter_all: option)

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def sort_tag_preference
    @old_preference = current_user.tag_sort
    @preference = params['commit'].downcase

    current_user.update!(tag_sort: @preference)

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def sort_playlist_preference
    @old_preference = current_user.playlist_sort
    @preference = params['commit'].downcase

    current_user.update!(playlist_sort: @preference)

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def users_export
    users = User.all

    respond_to do |format|
      format.html
      format.csv { send_data users.to_csv, filename: "users-#{Date.today}.csv" }
    end
  end
end
