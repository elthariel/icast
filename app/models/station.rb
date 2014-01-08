class Station < ActiveRecord::Base
  extend FriendlyId

  METAS = [ :artist, :title, :genre ]
  TAGS  = [ :location, :genre, :lang ]

  has_many :streams

  validates :name, presence: true, length: { minimum: 2 }

  METAS.each { |meta| delegate meta, to: :metadata, prefix: :current }

  friendly_id :name, use: :slugged
  acts_as_taggable_on TAGS

  #####################
  # Redis stored metas
  #
  def listeners
    Redis::Value.new(listeners_redis_key).value.to_i
  end
  def listeners=(value)
    Redis::Value.new(listeners_redis_key).value = value.to_i
  end

  def metadata
    StationMetadata.new(metadata_redis_key)
  end
  def metadata=(new_hash)
    hash = StationMetadata.new(metadata_redis_key)
    hash.update(new_hash)
  end

  private
  def listeners_redis_key
    "#{slug}__listeners"
  end
  def metadata_redis_key
    "#{slug}__metadata"
  end
end
