class DetailedStationSerializer < StationSerializer
  self.root = 'station'

  has_one :details
end
