class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :refresh_data!
  before_action :refresh_user_token!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :new_daily_challenge
  around_action :switch_locale

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def manage_achievements(tracks)
    untagged_tracks = tracks.select { |i| i.is_tag == false }.count
    @points = untagged_tracks * 10
    @status_changed = current_user.status_changed?(@points)
    @challenge_completed = update_challenge(untagged_tracks)
    current_user.add_points(@points)
    @status = current_user.status
  end

  def new_daily_challenge
    return if helpers.no_new_challenge_needed(current_user)

    DailyChallenge.create(user: current_user)
  end

  def refresh_data!
    return if helpers.no_data_refresh_needed(current_user)

    refresh_user_token! # this line shouldnt be necessary pablior
    DataUpdate.create(user: current_user, source: 'spotify')
    UpdateSpotifyDataJob.perform_later(current_user.id)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def switch_locale(&action)
    locale = current_user.try(:locale) || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def refresh_user_token!
    return if helpers.no_token_refresh_needed(current_user)

    resp = refresh_token
    update_spotify_token(resp)
  end

  def update_spotify_token(resp)
    token = current_user.spotify_token
    expiration_date = Time.now + resp['expires_in']

    token.update!(expires_at: expiration_date, code: resp['access_token'])
  end

  def update_challenge(count)
    challenge = current_user.daily_challenges.last
    if challenge.completed
      false
    else
      score = challenge.tracks_tagged
      challenge.update!(tracks_tagged: score + count)
      if challenge.tracks_tagged >= 10
        challenge.update!(completed: true)
        true
      else
        false
      end
    end
  end

  def refresh_token
    path = 'https://accounts.spotify.com/api/token'
    token = false
    content_type = nil
    client_id_and_secret = helpers.encode_credentials

    SpotifyApiCall.post(
      path,
      token,
      helpers.refresh_token_body(current_user.spotify_token.refresh_token),
      content_type,
      client_id_and_secret
    )
  end
end
