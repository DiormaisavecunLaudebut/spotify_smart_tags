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

def assign_random_tags(track, tags)
  n = (0..5).to_a.sample

  puts "adding #{n} tags\ntrack: #{track.name}\n\n"

  n.times do
    tag = tags.sample
    track.tag_list.add(tag) unless track.tag_list.include?(tag)
    track.save
  end
end

user = User.last
tags = %w[chill dark bright techno deep_house house minimalist joyful club afrika jazzy vocal instrumental remix sad]
user.tracks.each do |track|
  assign_random_tags(track, tags)
end
