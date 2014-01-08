class Stream < ActiveRecord::Base
  belongs_to :station

  validates :station_id, presence: true
  validates :uri, uri: true
  validates :mime, presence: true
end
