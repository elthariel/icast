require 'nokogiri'
require 'open-uri'

namespace :sync do
  desc 'Synchronize with dir.xiph.org (Xiph\'s Radio Directory)'
  task xiph: :environment do
    # dir = Nokogiri::XML(open('http://dir.xiph.org/yp.xml'))
    dir = Nokogiri::XML(open('/home/lta/Downloads/yp.xml'))

    puts "Starting Sync..."

    dir.xpath('//directory/entry').each do |entry|
      stream_hash = {
        name: entry.xpath('.//server_name').first.content,
        metadata: {
          title: entry.xpath('.//current_song').first.content,
          genre: entry.xpath('.//genre').first.content
        }
      }
      stream_uri_hash = {
        uri: entry.xpath('.//listen_url').first.content,
        mime: entry.xpath('.//server_type').first.content,
        bitrate: entry.xpath('.//bitrate').first.content,
        channels: entry.xpath('.//channels').first.content,
        samplerate: entry.xpath('.//samplerate').first.content,
        video: entry.xpath('.//server_type').first.content =~ /video/
      }

      next if stream_hash[:name].length < 2

      begin
        stream = Stream.friendly.find(stream_hash[:name].parameterize)
      rescue ActiveRecord::RecordNotFound
        puts "Creating Stream for #{stream_hash[:name]}"
        stream = Stream.create(name: stream_hash[:name])
      end
      puts "Updating Stream for #{stream_hash[:name]} (#{stream.slug})"
      stream.update_attributes(stream_hash)

      # FIXME Be a *little* bit more clever here (or less lazy, pick one)
      stream.stream_uris.destroy_all
      stream.stream_uris.create(stream_uri_hash)
    end
  end
end
