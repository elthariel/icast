module GeocodeRequest
  extend ActiveSupport::Concern

  attr_reader :geoip

  def geocode_request!
    if Rails.env.development? or Rails.env.test?
      @geoip = GEOIP.city('88.178.15.156')
    else
      @geoip = GEOIP.city(request.remote_ip)
    end
  end
end
