require 'nokogiri'
require 'open-uri'

namespace :sync do
  desc 'Synchronize with dir.xiph.org (Xiph\'s Radio Directory)'
  task xiph: :environment do
    dir = Nokogiri::XML(open('http://dir.xiph.org/yp.xml'))
    # FIXME Delete me
    #dir = Nokogiri::XML(open('/home/lta/Downloads/yp.xml'))

    puts "Starting Sync..."

    dir.xpath('//directory/entry').each do |entry|
      station_hash = {
        name: entry.xpath('.//server_name').first.content,
        metadata: {
          title: entry.xpath('.//current_song').first.content,
          genre: entry.xpath('.//genre').first.content
        }
      }
      stream_hash = {
        uri: entry.xpath('.//listen_url').first.content,
        mime: entry.xpath('.//server_type').first.content,
        bitrate: entry.xpath('.//bitrate').first.content,
        channels: entry.xpath('.//channels').first.content,
        samplerate: entry.xpath('.//samplerate').first.content,
        video: entry.xpath('.//server_type').first.content =~ /video/
      }

      next if station_hash[:name].length < 2

      begin
        station = Station.friendly.find(station_hash[:name].parameterize)
      rescue ActiveRecord::RecordNotFound
        puts "Creating Stream for #{station_hash[:name]}"
        station = Station.create(name: station_hash[:name])
      end
      puts "Updating Stream for #{station_hash[:name]} (#{station.slug})"
      station.update_attributes(station_hash)

      # FIXME Be a *little* bit more clever here (or less lazy, pick one)
      station.streams.destroy_all
      station.streams.create(stream_hash)
    end
  end
end
