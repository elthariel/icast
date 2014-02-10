class Stream < ActiveRecord::Base
  belongs_to :station, inverse_of: :streams

  validates :station, presence: true
  validates :uri,     uri: true
  validates :mime,    presence: true

  def icy_headers
    IcyHeaders.from_uri(self.uri)
  end
end
