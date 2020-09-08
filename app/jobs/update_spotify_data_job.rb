class UpdateSpotifyDataJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    user.fetch_spotify_data
  end
end
