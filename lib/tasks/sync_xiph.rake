namespace :sync do
  desc 'Synchronize with dir.xiph.org (Xiph\'s Radio Directory)'
  task xiph: :environment do
    # Parse xiph directory YellowPage with NokoGiri
    dir = Xiph::Directory.new 'http://dir.xiph.org/yp.xml'
    # FIXME Delete me
    # dir = Xiph::Directory.new '/home/lta/Downloads/yp.xml'

    puts "Starting Sync..."

    # Here we extract all the informations we've got from each station node.
    dir.each do |entry|
      station_hash = {
        name:       entry.normalized_name,
        genre_list: [entry.genre],
        metadata: {
          title: entry.current_title,
          genre: entry.genre
        },
        details_attributes: {
          origin: 'xiph_importer'
        }
      }
      stream_hash = {
        uri:        entry.stream_uri,
        mime:       entry.stream_mime,
        bitrate:    entry.stream_bitrate,
        channels:   entry.stream_channels,
        samplerate: entry.stream_samplerate,
        video:      entry.stream_video
      }

      next if station_hash[:name].length < 2 or station_hash[:name].parameterize.length <= 2

      ## Find or create Station Name
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
