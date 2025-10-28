require 'net/http'
require 'json'
require 'uri'

class TimetrapHarvest::NetworkClient
  attr_reader :email, :password, :subdomain

  def initialize(config)
    @email     = config.email
    @password  = config.password
    @subdomain = config.subdomain
  end

  def post(payload)
    req = Net::HTTP::Post.new(harvest_add_uri.request_uri)
    req.basic_auth(email, password)
    req.body            = payload.to_json
    req['Content-Type'] = 'application/json'
    req['Accept']       = 'application/json'

    res = Net::HTTP.start(harvest_add_uri.hostname, harvest_add_uri.port, use_ssl: true) do |http|
      http.request(req)
    end
  end

  def harvest_add_uri
    URI("https://#{subdomain}.harvestapp.com/daily/add")
  end
end
