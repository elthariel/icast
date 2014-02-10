require 'uri'

class WebsiteLanguageUpdater < BaseUpdater
  TLD_EXCLUDE  = [ 'com', 'net', 'io', 'fm', 'org', 'eu', 'tk', 'gov',
    'biz', 'info', 'edu', 'mobi' ]
  TLD_ISO2_MAP = {
    uk:   :gb
  }
  def update!
    begin
      URI(station.details.website).host =~ /\.([a-z]+)$/
      ext = $1

      return nil if TLD_EXCLUDE.include?(ext)
      if ext.length > 2
        puts "!!! This extension need mapping or exclusion: #{ext}"
        return nil
      end
      ext = TLD_ISO2_MAP[ext] if TLD_ISO2_MAP.has_key? ext

      puts "Station #{station.name} country = #{ext}"
      station.country = ext
      station.save
    rescue
      puts $!
    end
  end
end
