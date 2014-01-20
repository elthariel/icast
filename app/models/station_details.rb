class StationDetails < ActiveRecord::Base
  belongs_to :station, inverse_of: :details

  validate :station,    presence: true
  validate :website,    uri: true
  validate :email,      email: true
end
