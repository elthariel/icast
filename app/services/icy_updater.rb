class IcyUpdater
  attr_reader :station

  def initialize(station)
    @station = station
  end

  def update!
    begin
      Timeout::timeout(2) do
        stream = station.streams.first
        headers = stream.icy_headers

        if headers[:icy_br]
          stream.bitrate = headers[:icy_br]
        end
        if headers[:content_type]
          stream.mime = headers[:content_type]
        end

        if headers[:icy_genre]
          station.genre_list += headers[:icy_genre].split(" ").map &:downcase
          station.genre_list = station.genre_list.flatten.uniq.compact
        end

        if headers[:icy_name]
          station.name = Xiph::Entry.normalized_name(headers[:icy_name])
        end
        if headers[:icy_description]
          station.details.description = headers[:icy_description]
        end
        if headers[:icy_url]
          station.details.website = headers[:icy_url]
        end

        stream.save!
        station.save!
        station.details.save!
      end
    end
  rescue
    Rails.logger.error "#{self.class.name}, rescued from exception: #{$!}"
    Rails.logger.debug "Backtrace: #{$!.backtrace.join("\n")}"
  end
end
