require 'httparty'

class SpotifyApiCall < ApplicationRecord
  belongs_to :user

  def self.get(path, token, options = {})
    SpotifyApiCall.create(path: path)

    HTTParty.get(
      path,
      headers: { Authorization: token },
      query: options.to_query
    ).parsed_response
  end

  def self.post(path, token, body, content_type = false, encoded_clients = nil)
    call = SpotifyApiCall.create(path: path)

    body = body.to_json if content_type == 'application/json'

    HTTParty.post(
      path,
      headers: call.build_headers(content_type, token, encoded_clients),
      body: body
    ).parsed_response
  end

  def build_headers(content_type, token, encoded_clients)
    if content_type == 'application/json'
      { "Authorization" => token, "Content-Type" => content_type }
    elsif token == false
      {"Authorization" => "Basic #{encoded_clients}"}
    else
      { "Authorization" => token }
    end
  end
end
