class Station < ActiveRecord::Base
  extend FriendlyId

  include Authority::Abilities
  self.authorizer_name = 'StationAuthorizer'

  METAS = [ :artist, :title, :genre ]
  TAGS  = [ :genre, :tags ]

  # Station's owner
  belongs_to :user

  # Station's Streams
  has_many :streams
  accepts_nested_attributes_for :streams, allow_destroy: true

  # Station Details
  has_one  :details, class_name: 'StationDetails'
  after_create :create_details!
  accepts_nested_attributes_for :details

  # Validations
  validates :slug,     length: { minimum: 2 }, presence: true
  validates :name,     length: { minimum: 2 }, presence: true
  validates :country,  length: { maximum: 2 }
  validates :language, length: { maximum: 2 }

  # MetaData/Tags
  METAS.each { |meta| delegate meta, to: :metadata, prefix: :current }
  acts_as_taggable_on TAGS
  friendly_id :name, use: :slugged

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
