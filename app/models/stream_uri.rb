class StreamUri < ActiveRecord::Base
  belongs_to :stream

  validates :stream_id, presence: true
  validates :uri, uri: true
  validates :mime, presence: true
end
