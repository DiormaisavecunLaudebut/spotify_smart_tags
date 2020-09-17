class UsersController < ApplicationController

  def filter_all_option
    option = !current_user.filter_all
    current_user.update!(filter_all: option)

    respond_to do |format|
      format.html { redirect_to lior_path }
      format.js
    end
  end
end
