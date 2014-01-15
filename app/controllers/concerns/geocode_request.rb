module GeocodeRequest
  extend ActiveSupport::Concern

  def geocode_request!
    if Rails.env.development? or Rails.env.test?
      @geoip = GEOIP.city('88.178.15.156')
    else
      @geoip = GEOIP.city(request.remote_ip)
    end
  end
end
