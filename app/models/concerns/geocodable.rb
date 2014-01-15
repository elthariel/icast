module Geocodable
  extend ActiveSupport::Concern

  included do
    geocoded_by :geocodable_address
    before_save :geocode, if: -> (o) { o.geocodable_address_changed? and o.geocodable_address.present? }
  end

  def geocodable_address
    if city
      [city, state, country].compact.join(', ')
    else
      ""
    end
  end

  def geocodable_address_changed?
    city_changed? or state_changed? # or country_changed? FIXME, do we geocode country only ?
  end
end
