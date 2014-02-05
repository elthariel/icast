class StreamSerializer < ActiveModel::Serializer
  attributes :id, :uri, :video, :mime, :bitrate, :samplerate, :channels,
    :framerate, :width, :height

  def video
    object.video? ? 'true' : 'false'
  end

  def attributes
    hash = super

    unless object.video?
      [:framerate, :width, :height].each { |field| hash.delete(field) }
    end

    hash
  end
end
