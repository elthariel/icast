GEOIP_DB = [
  Rails.root.join('config', 'GeoIPCity.dat'),
  Rails.root.join('config', 'GeoLiteCity.dat')
]

GEOIP_DB.each do |path|
  if File.readable?(path)
    GEOIP = GeoIP.new(path)
    break
  end
end

unless defined? GEOIP
  msg = <<-EOS
    It appears you don't have Maxmind's GeoIP database installed.
    Please go to http://dev.maxmind.com/geoip/geoip2/geolite2/, download
    the city database and place it here: #{GEOIP_DB.join(' or ')}
  EOS
  puts msg
  Rails.logger.error msg
end
