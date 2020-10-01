require 'base64'

module ApplicationHelper
  def pluralise(string, count)
    case count
    when 0 then "aucun #{string}"
    when 1 then "#{count} #{string}"
    else "#{count} #{string}s"
    end
  end

  def encouragement
    ['All good!',
     'You rock',
     'Zone cleared',
     "Don't change",
     'Good boy!',
     "You're the best",
     "France love you"]
      .sample
  end

  def user_tracks_by_popularity(user_tracks)
    tags = {}

    user_tracks.each do |user_track|
      user_track.tag_list.each do |tag|
        tags[tag].nil? ? tags[tag] = 1 : tags[tag] += 1
      end
    end

    return tags
  end

  def standardize_tags(tags)
    tags.class == String ? tags.downcase : tags.map(&:downcase)
  end

  def pl_bk(ratio)
    if ratio == 100
      "background-linear-success"
    elsif ratio >= 66.66
      "background-points"
    else
      "background-linear-primary"
    end
  end

  def days_ago(playlist)
    seconds = (Time.now.to_i - Time.at(playlist.created_at.to_i).to_i)
    seconds / 606_024
  end

  def pl_cl(ratio)
    if ratio == 100
      "text-msuccess"
    elsif ratio >= 66.66
      "text-mwarning"
    else
      "text-mprimary"
    end
  end

  def set_cover_url(arr)
    cover_placeholder = "https://us.123rf.com/450wm/soloviivka/soloviivka1606/soloviivka160600001/59688426-music-note-vecteur-ic%C3%B4ne-blanc-sur-fond-noir.jpg?ver=6"
    arr.nil? || arr.empty? ? cover_placeholder : arr.first['url']
  end

  def new_offset(offset, limit, total)
    offset + limit < total ? offset += limit : nil
  end

  def no_data_refresh_needed(user)
    today = Date.today.all_day
    check1 = user.nil?
    check2 = user&.data_updates&.empty?
    check3 = user&.last_update('spotify') == today

    check1 || check2 || check3
  end

  def no_new_challenge_needed(user)
    today = Date.today.all_day
    check1 = user.nil?
    check2 = user&.last_challenge == today

    check1 || check2
  end

  def no_token_refresh_needed(user)
    check1 = user.nil?
    check2 = user&.spotify_token.nil?
    check3 = user&.valid_token? == true

    check1 || check2 || check3
  end

  def encode_credentials
    client_id = ENV['SPOTIFY_CLIENT']
    client_secret = ENV['SPOTIFY_SECRET']
    Base64.strict_encode64("#{client_id}:#{client_secret}")
  end

  def to_boolean(string)
    %w[on true].include?(string)
  end

  def serialize_track_info(user_track, tag_name = nil)
    track = user_track.track
    tags = user_track.tag_list
    tags.delete(tag_name) if tag_name
    [
      track.name,
      track.artist,
      track.cover_url,
      track.external_url,
      track.id,
      tags
    ].join('**')
  end

  def map_names(type, metadata)
    ids = metadata[type]['ids']
    return nil if ids.count.zero?

    path = "https://api.napster.com/v2.2/#{type}/" + ids.join(',')
    resp = HTTParty.get(URI.escape(path), headers: { "apikey" => ENV['NAPSTER_CLIENT']}).parsed_response
    resp[type].map { |i| i['name'] }.first(3)
  end

  def pretty_images
  [
    'https://media.gettyimages.com/photos/colorful-graffiti-over-a-cracked-surface-picture-id182213322?k=6&m=182213322&s=612x612&w=0&h=fA8-e1G2Xws_XOJFozMZlOfHyYYo_GMHFc3uHkgcpTA=',
    'https://media.gettyimages.com/photos/grafitti-artist-at-work-picture-id482629954?k=6&m=482629954&s=612x612&w=0&h=_XeESXqSZeOi6qyRhRsPrHRawFswtfC25zZ1B77lsOE=',
    'https://media.gettyimages.com/photos/mural-artist-at-work-picture-id1006914692?k=6&m=1006914692&s=612x612&w=0&h=k0Mon1Cnu7iBqKXh0653i77R2L9OPmqW3HN-0Icc0G0=',
    'https://media.gettyimages.com/photos/detail-of-graffiti-painted-illegally-on-public-wall-picture-id184869906?k=6&m=184869906&s=612x612&w=0&h=6t9h8vFXfiJ6qIbFgM18j6FuuBA3XSIApgOLUU17xDo=',
    'https://media.gettyimages.com/photos/young-woman-walking-past-how-nosm-street-art-mural-picture-id458248029?k=6&m=458248029&s=612x612&w=0&h=xzeV5rv8MbZ6G47FdkMcMq7XVb9kqkSd2d9_t9eQqxk=',
    'https://media.gettyimages.com/photos/stairway-tunnel-filled-with-graffiti-in-university-of-sydney-picture-id159757082?k=6&m=159757082&s=612x612&w=0&h=zV_Xw_YrZhwM8U9ivS9a19fKHvcpP_FN9c1apKVopi0=',
    'https://media.gettyimages.com/photos/wynwood-miami-graffiti-artist-spray-painting-colorful-mural-picture-id504586294?k=6&m=504586294&s=612x612&w=0&h=p-IA6hmFmKmoAHvpC3IWLp627EQe-vEJJ3CvxTfZFFM=',
    'https://media.gettyimages.com/photos/speech-balloon-on-white-wall-picture-id183237818?k=6&m=183237818&s=612x612&w=0&h=eA9OTwLkYzidEJoNVg74GMKSkUGeyPE1ffcsjyra56Y=',
    'https://media.gettyimages.com/photos/multi-colored-wall-picture-id557144497?k=6&m=557144497&s=612x612&w=0&h=ZD8g4rW-0cRCsdPV1kzsck19wahRzdQRZ8uDq1rH98c=',
    'https://media.gettyimages.com/photos/low-section-of-man-walking-on-road-picture-id1055233342?k=6&m=1055233342&s=612x612&w=0&h=ZaOSFJnDOIpwSn5a3DnPJpW1jGz6TVNjhHnu0Doqgi4=',
    'https://media.gettyimages.com/photos/full-frame-shot-of-graffiti-on-wall-picture-id746079101?k=6&m=746079101&s=612x612&w=0&h=JoSPhdHz6K6OlfuG4k1poZg3VrMrVL136D_Gik39s40=',
    'https://media.gettyimages.com/photos/colorful-graffiti-on-a-concrete-wall-picture-id171137169?k=6&m=171137169&s=612x612&w=0&h=Pm1K8aqroZh7E6HKyhn2PC-gquX03vtPH-Veu3p1pHc=',
    'https://media.gettyimages.com/photos/jef-arosol-picture-id526691885?k=6&m=526691885&s=612x612&w=0&h=3_GUoP3sxtCb4_-d0cGNTgRVwI1Kp2ze1bR6fH1virs=',
    'https://media.gettyimages.com/photos/street-artist-painting-graffiti-on-wall-picture-id709183265?k=6&m=709183265&s=612x612&w=0&h=ZJLpptSDeJXFfIBT66hZlf_vhnMpyRIQjlZBXct79hc=',
    'https://media.gettyimages.com/photos/murals-in-the-13th-arrondissement-of-paris-picture-id899985926?k=6&m=899985926&s=612x612&w=0&h=fyg7dNiGr6NjTETB48Rba5XhfdY52mErOGjR-_NsbTY=',
    'https://media.gettyimages.com/photos/people-picniking-at-espace-darwin-bordeaux-france-picture-id533356488?k=6&m=533356488&s=612x612&w=0&h=wxsXC1wiEVsODF2xS162qiSf77sCB6ZBcJunAhf9ED4=',
    'https://media.gettyimages.com/photos/las-vegas-nevada-picture-id184842367?k=6&m=184842367&s=612x612&w=0&h=qJnAe0Jy0OwOiGat0M02scuaVhO4fjh0mitpm6XYdSs=',
    'https://media.gettyimages.com/photos/an-artist-creats-a-mural-on-a-boxcar-picture-id544932309?k=6&m=544932309&s=612x612&w=0&h=DMsjetZbiDHfZ4EamfXorCY10rMbYs_5nP4sKSika54=',
    'https://media.gettyimages.com/photos/mural-artist-at-work-picture-id1002916974?k=6&m=1002916974&s=612x612&w=0&h=9EkMDuMcYuK7xmM1l-ZNAOCXAXGLPHoWSZu4Nuqo5vY=',
    'https://media.gettyimages.com/photos/yellow-taxi-and-mural-wall-on-houston-street-picture-id458681131?k=6&m=458681131&s=612x612&w=0&h=6hReSH2LRhZ0ZeghcUeEvl0eQ7in5P7yg6nRDLfl12Y=',
    'https://media.gettyimages.com/photos/rear-view-of-man-spraying-graffiti-on-wall-picture-id700845299?k=6&m=700845299&s=612x612&w=0&h=Q9Jt68lWkzrN9wceZljdI83KPhTZFXlc99jSElI1nFk=',
    'https://media.gettyimages.com/photos/silhouette-man-making-graffiti-on-wall-against-sky-during-sunset-picture-id760302637?k=6&m=760302637&s=612x612&w=0&h=fmMaqCOtVXzyCtSGKXy9th-A1tBRtuK4yB1ekXOFIuE=',
    'https://media.gettyimages.com/photos/red-heart-graffiti-on-wall-picture-id678884931?k=6&m=678884931&s=612x612&w=0&h=CIIbbLbAFikavNosUTJehd0OF2lVdgV47vPZnw4seVA=',
    'https://media.gettyimages.com/photos/grafitti-on-grungy-wall-picture-id482552340?k=6&m=482552340&s=612x612&w=0&h=pEPWGS7_WLLcZQsqDK-L0EQjG1On1Z1QBkiscLIRcZc=',
    'https://media.gettyimages.com/photos/rear-view-of-street-artist-painting-wall-with-spray-paint-picture-id688953781?k=6&m=688953781&s=612x612&w=0&h=Gl_xK0lB1k7pYD_6wBzZNjwJ_3J0asMC78pXHJn3HHo=',
    'https://media.gettyimages.com/photos/murals-and-people-in-paris-france-picture-id857403300?k=6&m=857403300&s=612x612&w=0&h=8dYu0qX6bfc8jv5tmy50vTOVe5s8F2bKORQhMjq0i20=',
    'https://media.gettyimages.com/photos/man-checks-cell-phone-walking-past-street-art-mural-picture-id458937111?k=6&m=458937111&s=612x612&w=0&h=Zh680CQyLK3_ec0P_FfhMcosvIYGBKAvFoNTovtlVr0=',
    'https://media.gettyimages.com/photos/living-on-the-edge-picture-id1149483678?k=6&m=1149483678&s=612x612&w=0&h=6CWfnbDwqV_NRKe5W_Ausmv4-RCdMam-V6EDW9rEagg=',
    'https://media.gettyimages.com/photos/people-drawing-colourful-pictures-with-chalk-on-a-concrete-wall-picture-id919436204?k=6&m=919436204&s=612x612&w=0&h=kD_LaCe6bOgJeoh2XDopMSuR-5uyND1nu_UzrHJ2-ZU=',
    'https://media.gettyimages.com/photos/white-washed-wall-picture-id122283917?k=6&m=122283917&s=612x612&w=0&h=PAv8RRMGuHXS8yNBozZ09YFQsv7nTeyrR-JnSvQaQSE=',
    'https://media.gettyimages.com/photos/woman-artist-create-graffiti-picture-id670502040?k=6&m=670502040&s=612x612&w=0&h=OSSzsIb3bl4pAFpznYcNFUShdBfmaSpcY4_l_VzBAZ4=',
    'https://media.gettyimages.com/photos/young-woman-painting-street-art-at-mornington-peninsula-victoria-picture-id613158074?k=6&m=613158074&s=612x612&w=0&h=TtDtX9Rtt-zA_DfS07Jojem7Qs-y2goa-TMeLznFN9g=',
    'https://media.gettyimages.com/photos/mural-artist-at-work-picture-id1006917008?k=6&m=1006917008&s=612x612&w=0&h=411XM8KeLEkMNalqigHnS8PEDNbtwEu19fLeW82zqLs=',
    'https://media.gettyimages.com/photos/street-artist-in-zaragoza-picture-id458988557?k=6&m=458988557&s=612x612&w=0&h=GGvh5lSAeoty9Hfkcn96Rjf-8GsF92EdGf8Y_-bzlCw=',
    'https://media.gettyimages.com/photos/new-york-skyline-picture-id140809637?k=6&m=140809637&s=612x612&w=0&h=IEzders8IomUD1voCWfDDQChIDgEuGXEPmJLycIRExw=',
    'https://media.gettyimages.com/photos/adelaide-tram-adorned-with-street-art-images-advertising-the-sala-picture-id1010645756?k=6&m=1010645756&s=612x612&w=0&h=dlTixbeWSJTbnF_3lcyz_v0ZhaOSf9Vv8vAsd_mpfu4=',
    'https://media.gettyimages.com/photos/urban-miami-wynwood-bike-parked-by-graffiti-street-art-mural-picture-id458338885?k=6&m=458338885&s=612x612&w=0&h=7dhbuyt0vYC_fQ08LZKTUK--XbMuzVQjAKjRdzvkWMo=',
    'https://media.gettyimages.com/photos/full-frame-photo-of-a-colorful-and-splattered-spray-paint-background-picture-id1070556092?k=6&m=1070556092&s=612x612&w=0&h=ryZaaPzKEsjdy9jvB6FHCKeyvwyvU_AP0DZK-kHBPJU=',
    'https://media.gettyimages.com/photos/young-girl-at-patershol-picture-id1084064634?k=6&m=1084064634&s=612x612&w=0&h=1byHpVU_OKXDLD5OZZym0dqj6xAj7Els3QxNZyQ0Y4I=',
    'https://media.gettyimages.com/photos/graffiti-artist-with-dreadlocks-picture-id1141314675?k=6&m=1141314675&s=612x612&w=0&h=SRNJ9fnwnVExxAcxK_3weMupb-PsGHU-IwW5QYSBHgU=',
    'https://media.gettyimages.com/photos/silhouette-of-young-female-street-dancer-picture-id876923580?k=6&m=876923580&s=612x612&w=0&h=yFBJnVawGZNr2TnvO5SI8xXujLYZ8s5aWHYYHoeCTzs=',
    'https://media.gettyimages.com/photos/street-hooligans-picture-id185213185?k=6&m=185213185&s=612x612&w=0&h=azqbRz4wkTIFJSpxx7bpZCsb8yntbatuoTggtoN0HEo=',
    'https://media.gettyimages.com/photos/side-view-of-street-artist-painting-on-wall-picture-id692782491?k=6&m=692782491&s=612x612&w=0&h=aQWpn1JPTnq7jEFhbdf9yMmjwgoFT8UA9yiXOAtSYAU=',
    'https://media.gettyimages.com/photos/colorful-graffiti-on-a-concrete-wall-picture-id171145335?k=6&m=171145335&s=612x612&w=0&h=KD001t9MdcWgL0_d4XDmXBPLGLHwBpSGa-tzfAeqtXM=',
    'https://media.gettyimages.com/photos/graffiti-in-barcelona-picture-id458619875?k=6&m=458619875&s=612x612&w=0&h=2gl-cnbfR5B5AxmNM3TbPMv7v50OrCLwbkEPJVCq3_g=',
    'https://media.gettyimages.com/photos/love-graffiti-letters-picture-id512179289?k=6&m=512179289&s=612x612&w=0&h=LO9a4Ndx5gA2rpQ0IBCXJEF0r4p7yC3mAL7a0T2BAnM=',
    'https://media.gettyimages.com/photos/mural-artist-at-work-picture-id1002917818?k=6&m=1002917818&s=612x612&w=0&h=LV1Je6Z9OyAFzUTstPAXNatXvNxtoWN7LnNNBpGR17w=',
    'https://media.gettyimages.com/photos/detail-of-graffiti-on-wall-picture-id665690381?k=6&m=665690381&s=612x612&w=0&h=-Z5fvJPbCCLdx7hesW06VSbRo-qkdSGXXkUVyHM49Sg=',
    'https://media.gettyimages.com/photos/female-mural-artist-arwork-picture-id1204986597?k=6&m=1204986597&s=612x612&w=0&h=vQVcElriH_lHV0hSg9CHAkVWXWYM8oJJEYuZWdUMcjw=',
    'https://media.gettyimages.com/photos/black-paint-on-wall-picture-id593462683?k=6&m=593462683&s=612x612&w=0&h=RgXSp7clsLM6d0UcUyg_eDRTXHajgw1MXaQoBVCR07o=',
    'https://media.gettyimages.com/photos/east-side-gallery-picture-id157733329?k=6&m=157733329&s=612x612&w=0&h=lyY3Pbxzpyj0L63oDu96CIZn_CPBF7p5sEmsQ_9u-f8=',
    'https://media.gettyimages.com/photos/blue-and-pink-abstract-painted-watercolor-illustration-picture-id1076731978?k=6&m=1076731978&s=612x612&w=0&h=mMcJKThH8DMlbENLHYHk2E0acyPRg_SpsDJtrUZcnBk=',
    'https://media.gettyimages.com/photos/no-longer-just-a-blank-wall-urban-graffiti-english-picture-id155076296?k=6&m=155076296&s=612x612&w=0&h=D8oL13unNNTilIRTq6bYmCUeRe6Hg-G1S4TC1euN3no=',
    'https://media.gettyimages.com/photos/red-heart-on-a-wall-picture-id171145952?k=6&m=171145952&s=612x612&w=0&h=IxEyMJAA8Cf0kbIBe7XtPB-oY8q1EddF5dGIqI2m9V4=',
    'https://media.gettyimages.com/photos/melbourne-painted-illegally-on-public-wall-picture-id184916256?k=6&m=184916256&s=612x612&w=0&h=YMcF2l8sA9hT39Nn0j07XCADzSpurZYK9Jxn9hqO2YU=',
    'https://media.gettyimages.com/photos/street-graffiti-in-central-bristol-picture-id458576983?k=6&m=458576983&s=612x612&w=0&h=Jplgz71F-4lVb_pKZSWsijMmHfnOQ_uo-dHNYUcTfJE=',
    'https://media.gettyimages.com/photos/france-rear-view-of-young-woman-in-front-of-colorful-mural-picture-id535828733?k=6&m=535828733&s=612x612&w=0&h=gIVqN6uB-6Vm5OBMskoW85ZGiN8HMePIJuuO9C3Yn60=',
    'https://media.gettyimages.com/photos/illuminated-tunnel-picture-id545793257?k=6&m=545793257&s=612x612&w=0&h=_IqyIK3_lYqdEWdUPl-oUf1tv5uygH1oGmYCr7wSz6g=',
    'https://media.gettyimages.com/photos/text-on-wall-picture-id558956007?k=6&m=558956007&s=612x612&w=0&h=a4FPxYXrp-scvOmOulqoPzFcys08PvBdGkefls5-fN0=',
    'https://media.gettyimages.com/photos/young-female-photographer-strolling-along-graffiti-alley-picture-id650163153?k=6&m=650163153&s=612x612&w=0&h=ZeyBOV67cnAcquVbuJNP71DnFprvrM6X1o_Wc859Pxg=',
    'https://media.gettyimages.com/photos/young-female-photographer-strolling-along-graffiti-alley-picture-id650163153?k=6&m=650163153&s=612x612&w=0&h=ZeyBOV67cnAcquVbuJNP71DnFprvrM6X1o_Wc859Pxg=',
    'https://media.gettyimages.com/photos/full-frame-shot-of-graffiti-on-weathered-wall-picture-id573914079?k=6&m=573914079&s=612x612&w=0&h=SzH78UQqZciWb0iXhm2PE1oXABAvnASYJA2saopGvHo=',
    'https://media.gettyimages.com/photos/detail-of-graffiti-art-or-vandalism-picture-id458556289?k=6&m=458556289&s=612x612&w=0&h=CLU15lxkZ6eLCdh0HqSVOS8LUEwtiuM9aKJCR3uZJkM=',
    'https://media.gettyimages.com/photos/rainbow-colored-lines-picture-id149478579?k=6&m=149478579&s=612x612&w=0&h=X6dZ5QXQBKcyefePB9IbKjpec4bvsh583_0jeJSEP9Y=',
    'https://media.gettyimages.com/photos/full-frame-of-spray-painting-bicycle-on-wall-picture-id550764135?k=6&m=550764135&s=612x612&w=0&h=QJK0FE3RnwjxfotnRNYbj_2tvyY2yOhEqGF3ywT2MoU=',
    'https://media.gettyimages.com/photos/toy-blocks-attached-to-wall-picture-id558973093?k=6&m=558973093&s=612x612&w=0&h=U84LCOQBGTHpPYKKgbT5889ycF91QnxkrZpY6iaifso=',
    'https://media.gettyimages.com/photos/new-york-state-new-york-city-dripping-paint-on-wall-and-asphalt-picture-id129311882?k=6&m=129311882&s=612x612&w=0&h=n-hVZPxz8kz94DlUjfTXF-K5v8G72IBQpRe_Kfw2d-s=',
    'https://media.gettyimages.com/photos/mona-lisa-unfinished-in-florence-italy-picture-id487525534?k=6&m=487525534&s=612x612&w=0&h=zA3fhX4hfMRteETehcevGTbwoN_O5kjVh3wXngAUH8U=',
    'https://media.gettyimages.com/photos/side-view-of-young-woman-with-tousled-hair-graffiti-wall-picture-id545804859?k=6&m=545804859&s=612x612&w=0&h=DiZ3qgfQah9wl3zRvuDi6xJHfprWkI6M-bBL8ve0S5w=',
    'https://media.gettyimages.com/photos/graffiti-artist-at-work-picture-id874327908?k=6&m=874327908&s=612x612&w=0&h=4ZBT1lwiGRtK8f8pYR4-pejaEEB3YJ5iEjs9_-TJqtE=',
    'https://media.gettyimages.com/photos/sticker-background-picture-id1173351352?k=6&m=1173351352&s=612x612&w=0&h=E6jo_pfXBNymkl_rxlYBFHsLHr4GZWcSLzE4u5A0kuQ=',
    'https://media.gettyimages.com/photos/laughing-young-woman-in-front-of-graffiti-wall-picture-id1020066896?k=6&m=1020066896&s=612x612&w=0&h=LhJtqUVeVAQKJ47MNeDNJ4un6pS9SwEWP7ZJiTYQ9iQ=',
    'https://media.gettyimages.com/photos/graffiti-of-young-girl-fishing-for-anarchy-sign-picture-id458582769?k=6&m=458582769&s=612x612&w=0&h=x0S7D-jxH8TBrPpeEg3yhaC634DMDDqg2c7tzv8uDLk=',
    'https://media.gettyimages.com/photos/full-frame-shot-of-multi-colored-spray-paint-cans-picture-id702609247?k=6&m=702609247&s=612x612&w=0&h=lBD1NAxLEgnVKazcWOdxmD7qlt0mKOAcPZOdbpiak9c=',
    'https://media.gettyimages.com/photos/graffiti-artist-with-copyspace-picture-id157295678?k=6&m=157295678&s=612x612&w=0&h=7MEKl2ZoUvG4MuONGhN7LQQIaxLTsp99KDqS1zxeuWk=',
    'https://media.gettyimages.com/photos/low-section-of-street-painter-holding-bottle-against-wall-picture-id660574069?k=6&m=660574069&s=612x612&w=0&h=gHtO3sI_q-qEmp7k2S6zXVjV155kk2olP5VYz4fKxxU=',
    'https://media.gettyimages.com/photos/boy-photographing-girl-holding-imaginary-painted-ballons-picture-id1083680244?k=6&m=1083680244&s=612x612&w=0&h=r3VF98yJJDtAEJZr3gSSLxyBy8nXGXBmuoClpcFo9xM=',
    'https://media.gettyimages.com/photos/cropped-image-of-artist-spray-painting-on-wall-picture-id722305717?k=6&m=722305717&s=612x612&w=0&h=4akhCNqtWZYPDsE2AxXPVDaxLz3bS9oTu2J_rP7jQUw=',
    'https://media.gettyimages.com/photos/closeup-of-human-hand-spray-painting-wall-picture-id564761203?k=6&m=564761203&s=612x612&w=0&h=ROclzqOKkWZwaWWmnLIbPxguGPBJiecDnbOvXanBSYU=',
    'https://media.gettyimages.com/photos/vibrant-abstract-painted-watercolor-illustration-picture-id1086898440?k=6&m=1086898440&s=612x612&w=0&h=P0Ac6s40sZmsVoVVtlFzcj2_sv8gex5LnnOfT1pfAy0=',
    'https://media.gettyimages.com/photos/manhattan-graffiti-on-the-chinatown-roofs-picture-id508036591?k=6&m=508036591&s=612x612&w=0&h=Bu2Gpy8KWen8r2zeG9dSjoDfC9WoKrU3wSKSivJeMgI=',
    'https://media.gettyimages.com/photos/bogot-colombia-a-local-yellow-taxi-drives-through-a-colorful-street-picture-id915914212?k=6&m=915914212&s=612x612&w=0&h=Bbldbf9DWW_DflZMKtl81Mh2Oc05JF0lGf3BrsmrYp4=',
    'https://media.gettyimages.com/photos/graffiti-artist-with-spray-paint-picture-id1145281091?k=6&m=1145281091&s=612x612&w=0&h=N2AGfavPLMY5Kj_8AuDG1lNycWIHSgpxhWBHA7AFj4A=',
    'https://media.gettyimages.com/photos/freetown-christiania-picture-id896409198?k=6&m=896409198&s=612x612&w=0&h=CMnnEHFK-IxtIy4Do4nfGAlPqmOEE7QntA0zGzNGK6s=',
    'https://media.gettyimages.com/photos/torn-poster-picture-id586077977?k=6&m=586077977&s=612x612&w=0&h=fov8g_0xpi5UMMwiqxriISK1hPzWcQep73aUtJXDTP0=',
    'https://media.gettyimages.com/photos/young-man-with-tattoo-on-hand-against-graffiti-wall-picture-id1129396027?k=6&m=1129396027&s=612x612&w=0&h=WStWoepPTGyQa20r0q5mjWPikY_LdzeB7yjFBeMhbvc=',
    'https://media.gettyimages.com/photos/side-view-of-person-spray-painting-on-wall-picture-id663748353?k=6&m=663748353&s=612x612&w=0&h=KS32JWCrj9paDnc0QpwYLMM5NFtOGC3pQ4FVz46C7DQ=',
    'https://media.gettyimages.com/photos/mural-artist-at-work-picture-id1003143882?k=6&m=1003143882&s=612x612&w=0&h=Gduacp19ROlwymqzxSNE61oX7bFqk5hIbOa_-4mwIHQ=',
    'https://media.gettyimages.com/photos/graffiti-on-old-wall-picture-id659080373?k=6&m=659080373&s=612x612&w=0&h=OT3At_4Q086DDbeIVIXNSvBbNCfUcKqTJVSRGw_Cz_k=',
    'https://media.gettyimages.com/photos/miami-wynwood-rainbow-colors-of-graffiti-art-spray-paint-cans-picture-id458321795?k=6&m=458321795&s=612x612&w=0&h=NlcRbac5gDW2b69PLC9NGWclem47mh95YGnU1PLATIo=',
    'https://media.gettyimages.com/photos/yellow-taxi-and-mural-wall-on-houston-street-picture-id458551051?k=6&m=458551051&s=612x612&w=0&h=qvbxGyfw2TeqPgATq_4YsFSTBxf9asXootH3PMWlIdI=',
    'https://media.gettyimages.com/photos/detail-of-graffiti-art-or-vandalism-picture-id458556301?k=6&m=458556301&s=612x612&w=0&h=GlH1zEFoGk4oSledAaGRpWu515kiOtDZPEOFeHUUTiY=',
    'https://media.gettyimages.com/photos/young-man-doing-graffiti-picture-id869911632?k=6&m=869911632&s=612x612&w=0&h=jMpUyH3_1qONbTF6rggvsw39vrDcQMebNeiBCDG_Ds0=',
    'https://media.gettyimages.com/photos/graffiti-artist-spray-painting-wall-venice-beach-california-usa-picture-id585358013?k=6&m=585358013&s=612x612&w=0&h=erE8Qcqvl5ZNz_oX60BNbFaakkeHFUWlSzqDbwnIvqM=',
    'https://media.gettyimages.com/photos/thailand-north-east-wall-art-of-chinese-water-dragon-and-fish-picture-id485214857?k=6&m=485214857&s=612x612&w=0&h=jgXG5fslBb5mM2AjVeoNsa-_pqOWjlQpRhVzwhwbtoo=',
    'https://media.gettyimages.com/photos/rear-view-full-length-of-street-artist-painting-graffiti-on-wall-picture-id692782773?k=6&m=692782773&s=612x612&w=0&h=FTEWs69Nnstuuv_cpsVE4Mo8ng4kEm4d_VF-_swq2vA=',
    'https://media.gettyimages.com/photos/street-art-created-in-september-2017-near-the-barbican-centre-in-by-picture-id876637954?k=6&m=876637954&s=612x612&w=0&h=jS6N1Tq59koBofnzYDLmwrt27s8LmvMftmWzNVjEpHc=',
    'https://media.gettyimages.com/photos/yellow-taxi-speeds-past-how-nosm-street-art-mural-picture-id458321801?k=6&m=458321801&s=612x612&w=0&h=EfKxHb357MdeKV1YZ0-zozdw-Axa-2hzTV9f-3YV1ME=',
    'https://media.gettyimages.com/photos/brooklyn-bridge-picture-id905753242?k=6&m=905753242&s=612x612&w=0&h=iwffZnzbFW_fNkBqr0gU2PhMhMVYsTUMgmf08b7kHs8=',
    'https://media.gettyimages.com/photos/anne-frank-centre-in-berlin-picture-id1028156730?k=6&m=1028156730&s=612x612&w=0&h=jh_1s93V7MXAAu7luhZl2u7OveGXZXVV4Wafv1ZuT14=',
    'https://media.gettyimages.com/photos/anne-frank-centre-in-berlin-mitte-picture-id1053812916?k=6&m=1053812916&s=612x612&w=0&h=GgoTahHrBh48FUL9ysNYsQDYwrVZd7mtmr1zWeqWpZc=',
    'https://media.gettyimages.com/photos/right-and-left-picture-id510317645?k=6&m=510317645&s=612x612&w=0&h=f9ofnQ_ZdzKatUCANA0rtiF8CWu5qt7Sm40VO6E4s1U=',
    'https://media.gettyimages.com/photos/graffiti-on-wall-picture-id577145805?k=6&m=577145805&s=612x612&w=0&h=OuWRNsD2J3TA8qpC76xpwiNOtoozJ3UXM5eibHBVo6w=',
    'https://media.gettyimages.com/photos/graffiti-artist-painting-picture-id1145280797?k=6&m=1145280797&s=612x612&w=0&h=2QHxmRpAOGeFBlvAmFIFX7uYpKu2qparT3YS9aDa5F8=',
    'https://media.gettyimages.com/photos/graffiti-orange-and-green-picture-id171137670?k=6&m=171137670&s=612x612&w=0&h=WA1b3VHyk4Y4Ii25Ior1CAe4MxxdbdDj4wmUF_j5ilw=',
    'https://media.gettyimages.com/photos/detail-of-graffiti-art-or-vandalism-picture-id458683089?k=6&m=458683089&s=612x612&w=0&h=sbsAVWPSTInlhqmTArtr5z_VCLpe3F9UGOxrFaa-ZJ4=',
    'https://media.gettyimages.com/photos/portrait-of-woman-in-red-dress-picture-id736520127?k=6&m=736520127&s=612x612&w=0&h=LMswk3j8MTWcu0LfUvtK0zJUXfHckeurnOkkkH6cgJc=',
    'https://media.gettyimages.com/photos/look-how-beautiful-picture-id471500601?k=6&m=471500601&s=612x612&w=0&h=Wglx88XU1enm7TzG6UtcOsfwLWJfjth3uflFpm_qBLs=',
    'https://media.gettyimages.com/photos/urban-young-woman-listening-to-music-picture-id1145279082?k=6&m=1145279082&s=612x612&w=0&h=cinTI_exyQunOjqZ0uoRXJVpbW62BCA7tBwnyKKKeZo=',
    'https://media.gettyimages.com/photos/young-woman-walking-past-how-nosm-street-art-mural-picture-id458264549?k=6&m=458264549&s=612x612&w=0&h=cDH0YTF6VZUYDgIUzVg1p9M5MxVSEuqVAQ08t6q9R_k=',
    'https://media.gettyimages.com/photos/graffiti-against-old-building-wall-picture-id458678081?k=6&m=458678081&s=612x612&w=0&h=oPUDDAkyNX8IH_RM71m-dBvvIqoUsOtYU5-yy3IQdUg=',
    'https://media.gettyimages.com/photos/murals-and-people-in-paris-france-picture-id458932019?k=6&m=458932019&s=612x612&w=0&h=q5qmXxfs0BxV-t5crdpHwKzZIv9mEQ79B2AM9XIjlsQ=',
    'https://media.gettyimages.com/photos/policeman-writing-a-ticket-for-an-illegally-parked-motorcycle-in-in-picture-id525526972?k=6&m=525526972&s=612x612&w=0&h=JJJvT6pu4_ipu9fq-D1vuv3wwoMYe4PZfaz0AInYGK4=',
    'https://media.gettyimages.com/photos/dancer-image-in-cobra-pose-on-grey-brick-wall-picture-id723500845?k=6&m=723500845&s=612x612&w=0&h=3DSwPzHCyfgW8HbUwp56KPP4X0dExBBvieksBy2NLpY=',
    'https://media.gettyimages.com/photos/teenage-girl-is-dancing-modern-street-dance-picture-id876923522?k=6&m=876923522&s=612x612&w=0&h=mQtzXWAbkE62uGAh2VQHSZ_uYqCH8Kwocyt2XIkWw5M=',
    'https://media.gettyimages.com/photos/graffiti-artist-painting-picture-id1145280765?k=6&m=1145280765&s=612x612&w=0&h=Z_HnL7mBEL3_Divs051FxK5kyjr8SmlsQuJa045x2LI=',
    'https://media.gettyimages.com/photos/berlin-cityscape-with-road-traffic-picture-id543631357?k=6&m=543631357&s=612x612&w=0&h=RYKaHZD3jxjzAcFykh6yrk1kcY6graooT5-P_qZRMHM=',
    'https://media.gettyimages.com/photos/two-men-waiting-in-front-of-billymarks-west-restaurant-in-9th-ave-picture-id1143189362?k=6&m=1143189362&s=612x612&w=0&h=wU2UC9Nrw2dydNjDK3PUeR2128U6f0VorMrYGJzztCw=',
    'https://media.gettyimages.com/photos/young-man-taking-selfie-in-front-of-the-berlin-wall-picture-id523734255?k=6&m=523734255&s=612x612&w=0&h=fU82ug-U4eit7CzTHpG7mY0ECrBbGVe6_EdgPbTa8sE=',
    'https://media.gettyimages.com/photos/colourful-abstract-detail-of-painted-wall-picture-id490596463?k=6&m=490596463&s=612x612&w=0&h=BRxQ7dc5aRtwkKSyFXIjXpr8S_PZADe_UXzp28vadl0=',
    'https://media.gettyimages.com/photos/colourful-abstract-detail-of-painted-wall-picture-id490596463?k=6&m=490596463&s=612x612&w=0&h=BRxQ7dc5aRtwkKSyFXIjXpr8S_PZADe_UXzp28vadl0=',
    'https://media.gettyimages.com/photos/man-leaning-on-graffiti-wall-picture-id1134058852?k=6&m=1134058852&s=612x612&w=0&h=EjObznVOu2NAebVfVo2_LQmbmkfwtAaGjVMJY4AqEFY=',
    'https://media.gettyimages.com/photos/hong-kong-facade-road-picture-id503168781?k=6&m=503168781&s=612x612&w=0&h=Hud4UIRegEgAfC9Axu6OpjzwWAC_qimv4LK1-fod4x4=',
    'https://media.gettyimages.com/photos/great-white-shark-picture-id166672817?k=6&m=166672817&s=612x612&w=0&h=6sp7nniOH4YywuhV5qflc8Wk5ah6DRoXmZsJbwSuZJk=',
    'https://media.gettyimages.com/photos/young-women-jumping-in-mid-air-picture-id565785237?k=6&m=565785237&s=612x612&w=0&h=LoGkKjuPPns7nbZ7mfby76wZVLbqGY9VmaWkISQI6jQ=',
    'https://media.gettyimages.com/photos/low-section-of-man-standing-by-animal-representations-picture-id962863182?k=6&m=962863182&s=612x612&w=0&h=FkihQWUuNUokFxt_QNOsQWfXYc3NwqSybpI1nbRHqjY=',
    'https://media.gettyimages.com/photos/portrait-of-young-woman-with-friend-at-a-graffiti-wall-picture-id1150929502?k=6&m=1150929502&s=612x612&w=0&h=OD_dr8eJq4jFY90DvGkCccECoWw8qleNlIm3lZrDqJI=',
    'https://media.gettyimages.com/photos/female-graffiti-artist-is-drawing-picture-id670502204?k=6&m=670502204&s=612x612&w=0&h=TKTZkZqII4wS3VLlEYbi6KLUrh8kUe_bkLfI9V1WKjU=',
    'https://media.gettyimages.com/photos/arrow-symbols-on-blue-wall-picture-id629721565?k=6&m=629721565&s=612x612&w=0&h=mwlrthZl193q0_ysz0tRXuB592ZzIWgVLUK003i-lhc=',
    'https://media.gettyimages.com/photos/creating-a-grafitti-picture-id482629930?k=6&m=482629930&s=612x612&w=0&h=3rTli60ai7j9uUhHhAREnXjzUOsAxBDKdnlwd2hqAOc=',
    'https://media.gettyimages.com/photos/chelsea-square-market-manhattan-new-york-usa-picture-id1143189424?k=6&m=1143189424&s=612x612&w=0&h=441s4fXJncbkrtYCLZgyWpJOrasBlyqLHRiT6FdAZ6I=',
    'https://media.gettyimages.com/photos/bogot-colombia-traffic-drives-through-the-colorful-streets-of-the-la-picture-id915476396?k=6&m=915476396&s=612x612&w=0&h=JAD2YMtxot-SMfkQEPfASf2TJdQ3vciRU2QWSBsr8R8=',
    'https://media.gettyimages.com/photos/cafe-cinema-berlin-picture-id623207208?k=6&m=623207208&s=612x612&w=0&h=JengO1GKj2NNUNLDGjmQi3dOT2dQYy4ki-XxaAlMs9g=',
    'https://media.gettyimages.com/photos/the-broussaille-wall-in-brussels-picture-id845085386?k=6&m=845085386&s=612x612&w=0&h=ca4KY0vElZ3UXmhEF6dee6oJR3GeT6ncQcLFshFK6hg=',
    'https://media.gettyimages.com/photos/manhattan-buildings-inside-a-glass-ball-picture-id905746586?k=6&m=905746586&s=612x612&w=0&h=xiuqzIYchMj4w8wc7LkICNTxHWg03WpDrwlbgCowgTA=',
    'https://media.gettyimages.com/photos/cropped-image-of-hand-spraying-paint-on-wall-picture-id649145283?k=6&m=649145283&s=612x612&w=0&h=zlGTZNOFQ-b3OEI9S8A1sIlXm_MOPVQNuyoM3bImkMY=',
    'https://media.gettyimages.com/photos/people-on-city-street-against-sky-picture-id577155523?k=6&m=577155523&s=612x612&w=0&h=4qX4Z9w1p21I6ZH8iBvxmHUJexK8f35veGx_JLgngro=',
    'https://media.gettyimages.com/photos/woman-sitting-on-a-mans-shoulders-attaching-colourful-cloud-shapes-to-picture-id919435868?k=6&m=919435868&s=612x612&w=0&h=tiYXDGpMN1Tk0GtJlqh-wtLcQE6cXcGDhL07lwRZ4EU=',
    'https://media.gettyimages.com/photos/street-art-paris-france-picture-id139239667?k=6&m=139239667&s=612x612&w=0&h=3T0LzbE3eDoOUTd5PL10kPneW2Pljdub5f4qoGy28K8=',
    'https://media.gettyimages.com/photos/full-frame-shot-of-wall-picture-id972911306?k=6&m=972911306&s=612x612&w=0&h=kynh_3Iq5ZX5UoM_i-auFIItFpF9TvQdVBPcrwkf2U4=',
    'https://media.gettyimages.com/photos/heart-shape-graffiti-on-metallic-wall-picture-id700813857?k=6&m=700813857&s=612x612&w=0&h=kDFfpRzVgRwHLM-5q7O3pKSJDzcUuluS6Ex3zRStivc=',
    'https://media.gettyimages.com/photos/detail-of-graffiti-art-or-vandalism-picture-id459391845?k=6&m=459391845&s=612x612&w=0&h=Vxn8qT15v836V1SOWOPa5X0PmaZzuzDuO5vftNYvXA8=',
    'https://media.gettyimages.com/photos/love-graffiti-letters-picture-id512179067?k=6&m=512179067&s=612x612&w=0&h=cGR41D2-QLnxg3-RhJOs742B7bBX2GHmYp2vPnBRXL8=',
    'https://media.gettyimages.com/photos/graffiti-artist-with-dreadlocks-picture-id1141314653?k=6&m=1141314653&s=612x612&w=0&h=l8jPh5scI-NNBphItH-Vh7oPF8khAbco_2XL3Pe0uvc=',
    'https://media.gettyimages.com/photos/brightly-painted-city-walls-in-nyc-usa-picture-id509025799?k=6&m=509025799&s=612x612&w=0&h=_kPBojEOltTqLdoK7PDVm-a2hlGasqxXjM8j7YCpRu8=',
    'https://media.gettyimages.com/photos/boy-with-aerosol-paint-looking-at-camera-picture-id649197820?k=6&m=649197820&s=612x612&w=0&h=eZKjDcuoyzm7ilcQBSth1VcHqVufFksz89ctez76p6k=',
    'https://media.gettyimages.com/photos/detail-of-graffiti-picture-id458648641?k=6&m=458648641&s=612x612&w=0&h=CHgwKujRCvIZ2G5GDHhf8yhp2VoNBapCfWqhFihaQn8=',
    'https://media.gettyimages.com/photos/abandoned-shopping-cart-against-painting-on-wall-picture-id641019167?k=6&m=641019167&s=612x612&w=0&h=RDtbJG9Nio2gTzcmlZdwxB0M-GsO7NlAWJXj-W3fV9Q=',
    'https://media.gettyimages.com/photos/twilight-over-the-famous-canal-and-duth-style-houses-in-amsterdam-picture-id1026973386?k=6&m=1026973386&s=612x612&w=0&h=BRUo1Kv0nTPdUF9igv9tBHw7NlMjkrLUMTJCOE3uvGE=',
    'https://media.gettyimages.com/photos/charming-paris-picture-id1167397791?k=6&m=1167397791&s=612x612&w=0&h=5YYEqC-QozwkawlvxlsIbwosr71ot6UE-OZAQ4wjg3o=',
    'https://media.gettyimages.com/photos/mural-artist-at-work-picture-id1006916880?k=6&m=1006916880&s=612x612&w=0&h=hB5gt5HbJEWJ9rNRwZcZUMhvM_U5_BtiwLoD_0Nw95c=',
    'https://media.gettyimages.com/photos/graffiti-artist-with-spray-paint-picture-id1145280849?k=6&m=1145280849&s=612x612&w=0&h=fNg06fRPEhZfG5D20sLfIvtoMEzKlbGZlv1v-5dO7og=',
    'https://media.gettyimages.com/photos/che-guevara-is-watching-picture-id1140795341?k=6&m=1140795341&s=612x612&w=0&h=xMOxMBSzlF1t8kT9JI1AbBwvHEWGWfaKvNYOhhnD79M=',
    'https://media.gettyimages.com/photos/square-in-le-panier-picture-id486097802?k=6&m=486097802&s=612x612&w=0&h=NV7-3y9ztmIbS3x3UpGIP8p074owARVsw-4F1JX_t1w=',
    'https://media.gettyimages.com/photos/side-view-of-street-artists-painting-graffiti-on-wall-picture-id685081363?k=6&m=685081363&s=612x612&w=0&h=0bArds5HU8OJn8DkK6ea3PI_mzIE8NaP0b73hQ2_4pw=',
    'https://media.gettyimages.com/photos/france-paris-wall-with-glass-of-wine-sign-picture-id158935026?k=6&m=158935026&s=612x612&w=0&h=PwvLqSwyh3fuyqxxtrc_KoioRJt3HHizV2EIZL3FbDg=',
    'https://media.gettyimages.com/photos/east-side-gallery-in-berlin-picture-id458247897?k=6&m=458247897&s=612x612&w=0&h=Z0qnFiihEjeSoD0BdPV8STj6mdeOBsnV3Bf9hKO35Pw=',
    'https://media.gettyimages.com/photos/graffiti-on-groyne-rocks-against-blue-sky-picture-id561306759?k=6&m=561306759&s=612x612&w=0&h=TBVp-9uyuKqa7T8YmHkpZ398rN_WDpVJ6Pzoog8ikiE=',
    'https://media.gettyimages.com/photos/grafitti-artist-at-work-picture-id482629940?k=6&m=482629940&s=612x612&w=0&h=1cGKdKPhKkKGyY-xcKn7xDLno9XPYn24-apJEtRyI5I=',
    'https://media.gettyimages.com/photos/detail-of-graffiti-picture-id459394227?k=6&m=459394227&s=612x612&w=0&h=Y0YkgKtbMkIs3mUcP3fBzjnARnmlZhbBpZa3BD4-jto=',
    'https://media.gettyimages.com/photos/graffiti-artists-picture-id1039985456?k=6&m=1039985456&s=612x612&w=0&h=nAA2eVrV3ncmkX-mO6sjuNl6-RGjiZUFwRxOV4Pr9zA=',
    'https://media.gettyimages.com/photos/stylish-teenage-girl-photographing-with-camera-in-front-of-graffiti-picture-id561126973?k=6&m=561126973&s=612x612&w=0&h=0d_96mG0mczEYidJLjwSuWFTqZxtLr2dWbnLYpZ6FnI=',
    'https://media.gettyimages.com/photos/graffiti-in-paris-picture-id1134819440?k=6&m=1134819440&s=612x612&w=0&h=U8vrDWqEOwfaR1IPdJr9pl6ZVAyWRDpzMAm3yWF48ew=',
    'https://media.gettyimages.com/photos/fiesta-mayor-de-gracia-festival-barcelona-picture-id627148846?k=6&m=627148846&s=612x612&w=0&h=Q3dAyc9DNIYCtcCanW3AhDWhMyaOjK5LDGDdVjH80Yc=',
    'https://media.gettyimages.com/photos/colorful-graffiti-on-a-concrete-wall-picture-id154835692?k=6&m=154835692&s=612x612&w=0&h=OaY8wBooNDyreQkMCZUQEsVj1jPS78E1IRr4LTh2q1o=',
    'https://media.gettyimages.com/photos/graffiti-artist-with-dreadlocks-picture-id1141314858?k=6&m=1141314858&s=612x612&w=0&h=znBuBhz7ROg3rxBJz8z54fM9cR63vB_6V1ElKf8nf8s=',
    'https://media.gettyimages.com/photos/year-old-boy-with-boxing-gloves-in-front-of-a-huge-mural-of-himself-picture-id1054807532?k=6&m=1054807532&s=612x612&w=0&h=hgeFBg1tJh9aHRQqMQ1Dr55nGVFjlkTvugoWAreK1LE=',
    'https://media.gettyimages.com/photos/muscular-graffiti-break-dancer-picture-id566339097?k=6&m=566339097&s=612x612&w=0&h=csYgdlcgwtB0ILWDnBKBwqWJU2pV1o-wJhmaF8gH4FA=',
    'https://media.gettyimages.com/photos/new-jersey-jersey-city-portrait-of-smiling-woman-with-headphones-picture-id140192730?k=6&m=140192730&s=612x612&w=0&h=ySDopmIReB9AaF7wz1_8r-PGYYWdfVg3sJfnG18cjmM=',
    'https://media.gettyimages.com/photos/portrait-of-young-woman-at-a-graffiti-wall-picture-id1150928049?k=6&m=1150928049&s=612x612&w=0&h=qxirVf6lEOxOnxaQDb4z-coSt3qA3nCxKMV5pK5EiCM=',
    'https://media.gettyimages.com/photos/young-woman-on-cruiser-bicycle-picture-id1047098790?k=6&m=1047098790&s=612x612&w=0&h=I4ndNxnqG9irUsGSt2ZyRxCPkk_eQ4kVT9LccW2BZEo=',
    'https://media.gettyimages.com/photos/an-artist-creats-a-mural-on-a-boxcar-picture-id544932303?k=6&m=544932303&s=612x612&w=0&h=biYDPhh6yCeDhI7hjeC__iuiQLXGWYPIbT6saPAmmQ0=',
    'https://media.gettyimages.com/photos/graffiti-painter-cheerful-woman-picture-id670502144?k=6&m=670502144&s=612x612&w=0&h=P1xqCAMIhcug0LUPoxGiwKj8WtwVOzBzdEstKQNoloI=',
    'https://media.gettyimages.com/photos/the-3d-street-painting-crevasse-by-artist-edgar-mueller-is-seen-in-picture-id85014034?k=6&m=85014034&s=612x612&w=0&h=Gn5Z4R4h9zeNngUa6VnANAxpB6jjJ36NwNmGHUjQEY0=',
    'https://media.gettyimages.com/photos/girl-standing-on-ladder-drawing-colourful-pictures-with-chalk-on-a-picture-id919436326?k=6&m=919436326&s=612x612&w=0&h=2u37ncAbD-WXgejIALuDxCCj9a51Xl5XL74LTfhpFUQ=',
    'https://media.gettyimages.com/photos/street-photography-at-stuttgart-underground-station-picture-id988410278?k=6&m=988410278&s=612x612&w=0&h=dxVTE2MBgNdATwAjZVBAT1tnD1dhzcOBGrN2-jMJhow=',
    'https://media.gettyimages.com/photos/open-view-of-espace-darwin-bordeaux-france-picture-id533355826?k=6&m=533355826&s=612x612&w=0&h=ERU8MAJLZnAOeNEAos41rbwALH_jvKOyCae9EssFUUY=',
    'https://media.gettyimages.com/photos/faixa-azul-no-cabelo-picture-id486666177?k=6&m=486666177&s=612x612&w=0&h=S3zbgOQriTVwaf_qaN7e_TdI9vmIlVi99fqUXyGrwr8=',
    'https://media.gettyimages.com/photos/houses-in-the-city-quarter-marollen-picture-id832350016?k=6&m=832350016&s=612x612&w=0&h=2d7MA4yqX2VKwGYu3J3RH_6O372pZdn9cXCWxmUKTqw=',
    'https://media.gettyimages.com/photos/freedom-mural-on-a-wall-of-the-town-picture-id541346902?k=6&m=541346902&s=612x612&w=0&h=mhaNf8k_iDyY7U861ek5Dax7ZDIdRh3lsZ5BQVBm7oE='
  ]
  end
end
