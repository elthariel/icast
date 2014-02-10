class BaseUpdater
  attr_reader :station

  def initialize(station)
    @station = station
  end

  def update!
    raise "Implement me #{self.class}#update!"
  end
end
