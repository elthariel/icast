class StationSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :slogan, :country, :language, :current

  def current
    object.metadata.all
  end

  has_many :streams
end
