require 'timeout'

class Station < ActiveRecord::Base
  extend FriendlyId

  include Authority::Abilities
  self.authorizer_name = 'StationAuthorizer'

  METAS = [ :artist, :title, :genre ]
  TAGS  = [ :genre, :tags ]

  # Station's owner
  belongs_to :user

  # Station's Streams
  has_many :streams, dependent: :destroy, inverse_of: :station
  accepts_nested_attributes_for :streams, allow_destroy: true

  # Station Details
  has_one  :details, class_name: 'StationDetails', dependent: :destroy#, inverse_of: :station
  after_create :create_details!, unless: :details
  accepts_nested_attributes_for :details

  has_many :contributions, as: :contributable

  # Validations
  validates :slug,     length: { minimum: 2 }, presence: true
  validates :name,     length: { minimum: 2 }, presence: true
  validates :country,  length: { maximum: 2 }
  validates :language, length: { maximum: 2 }

  # Station Logo
  mount_uploader :logo, StationLogoUploader

  # MetaData/Tags
  METAS.each { |meta| delegate meta, to: :metadata, prefix: :current }
  acts_as_taggable_on TAGS
  friendly_id :name, use: :slugged

  # Pagination
  paginates_per 20
  max_paginates_per 100

  # GeoCoding
  include Geocodable
  delegate :city, :state, :city_changed?, :state_changed?, to: :details

  include StationSearch

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

  ######################
  # Base64 FileUpload.
  # Used by contributions
  def base64_logo=(data)
    io = Base64FileUpload.new(data)
    self.logo = io
  end

  def merge_other!(other_station)
    return if other_station.id == self.id

    # Merge attributes, but self's one take precedence
    self.attributes = other_station.attributes.merge(self.attributes)
    self.details.attributes = other_station.details.attributes.merge(self.details.attributes)

    # Move other_station's streams to our streams if it doesn't exist yet
    other_station.streams.each do |stream|
      if streams.where(uri: stream.uri).first
        stream.destroy
      else
        stream.station_id = self.id
        stream.save!
      end
    end

    details.save!
    save!
    other_station.reload.destroy
  end

  private
  def listeners_redis_key
    "#{slug}__listeners"
  end
  def metadata_redis_key
    "#{slug}__metadata"
  end
end
