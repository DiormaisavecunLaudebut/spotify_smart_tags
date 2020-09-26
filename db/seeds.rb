def reset_tags(user_track, user)
  puts "reseting tags for track #{user_track.track.name}"
  tags = user_track.tags.map(&:name)

  user_track.remove_tags(tags, user)
end

def assign_random_tags(user_track, user)
  tags = %w[chill dark bright techno house minimalist joyful club afrika jazzy vocal remix sad motivational smooth]
  n = (0..5).to_a.sample
  puts "adding #{n} tags to track: #{user_track.track.name}\n"

  new_tags = tags.sample(n)
  user_track.add_tags(new_tags, user)
end

# user = User.where(username: 'pablior').take

# user.user_tracks.each do |user_track|
#   assign_random_tags(user_track, user)
# end

# user.user_tracks.each do |user_track|
#   reset_tags(user_track, user)
# end
