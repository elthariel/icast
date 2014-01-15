module Geocodable
  extend ActiveSupport::Concern

  included do
    geocoded_by :geocodable_address
    before_save :geocode, if: -> (o) { o.geocodable_address_changed? }
  end

  def geocodable_address
    [city, state, country].compact.join(', ')
  end

  def geocodable_address_changed?
    city_changed? or state_changed? # or country_changed? FIXME, do we geocode country only ?
  end
end
