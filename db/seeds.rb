def reset_track_tags(track)
  puts "reseting tags for track #{track.name}"
  track.tag_list = []
  track.is_tag = false
  track.save
end

def assign_random_tags(track, tags, user)
  n = (0..5).to_a.sample

  puts "adding #{n} tags to track: #{track.name}\n"

  new_tags = tags.sample(n)

  new_tags.each do |tag|
    track.add_tag(tag, user)
    user.add_tag(tag)
  end
end

tags = %w[chill dark bright techno house minimalist joyful club afrika jazzy vocal remix sad motivational smooth]
user = User.where(username: 'pablior').take

user.tracks.each do |track|
  # reset_track_tags(track)
  assign_random_tags(track, tags, user)
end
