# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# PlaylistTrack.where(created_at: Date.today.all_day).each(&:destroy)
# Playlist.where(created_at: Date.today.all_day).each(&:destroy)
# Track.where(created_at: Date.today.all_day).each(&:destroy)

# SpotifyToken.destroy_all
# PlaylistTrack.destroy_all
# Playlist.destroy_all
# Track.destroy_all
# User.destroy_all
def reset_track_tags(track)
  puts "reseting tags for track #{track.name}"
  track.tag_list = []
  track.save
end

def assign_random_tags(track, tags, user)
  n = (0..5).to_a.sample

  puts "adding #{n} tags to track: #{track.name}\n"

  new_tags = tags.sample(n)
  track.add_tags(new_tags, user)
end

user = User.where(username: "pablior").take
tags = %w[chill dark bright techno deep_house house minimalist joyful club afrika jazzy vocal instrumental remix sad rap motivational]
user.add_tags(tags)

user.tracks.each do |track|
  reset_track_tags(track)
  assign_random_tags(track, tags, user)
end
