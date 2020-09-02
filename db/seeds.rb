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

PlaylistTrack.destroy_all
Playlist.destroy_all
Track.destroy_all
User.destroy_all
