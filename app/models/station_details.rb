class StationDetails < ActiveRecord::Base
  belongs_to :station#, inverse_of: :details

  validate :station_id, presence: true
  validate :website,    uri: true
  validate :email,      email: true

  mount_uploader :logo, StationLogoUploader
end
