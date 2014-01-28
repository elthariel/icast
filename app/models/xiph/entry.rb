class Xiph::Entry
  NORMALIZATION_THRES = 10

  ATTRIBUTES = {
    name:               :server_name,
    genre:              :genre,
    current_title:      :current_song,
    stream_uri:         :listen_url,
    stream_mime:        :server_type,
    stream_bitrate:     :bitrate,
    stream_channels:    :channels,
    stream_samplerate:  :samplerate
  }

  attr_reader :xml

  def initialize(xml_node)
    @xml = xml_node
  end

  ATTRIBUTES.each do |name, xml_name|
    define_method name do
      begin
        self.xml.xpath(".//#{xml_name}").first.content
      rescue
        puts "Entry has no field #{xml_name}"
        ""
      end
    end
  end

  def stream_video
    self.stream_mime =~ /video/
  end

  def normalized_name
    self.class.normalized_name(self.name)
  end

  # Dirty normalization process :-/
  def self.normalized_name(name)
    if name.length > NORMALIZATION_THRES
      tmp_name = name.gsub(/radio\ /i, '').gsub(/\(.*\)/, '').gsub(/\[.*\]/, '')
      ['//', ',', '- ', '- ', '  ', '::'].each do |separator|
        if tmp_name.split(separator)[0]
          tmp_name = tmp_name.split(separator)[0]
        end
      end

      if tmp_name.length <= 3
        name
      else
        if tmp_name.length > NORMALIZATION_THRES
          tmp_name.split(' ')[0,2].join(' ')
        else
          tmp_name.strip
        end
      end
    else
      name
    end
  end
end
