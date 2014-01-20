class StationSerializer < ActiveModel::Serializer
  attributes :id, :slug, :name, :slogan, :country, :language, :current,
    :genre_list, :logo

  def current
    object.metadata.all
  end

  def logo
    if object.logo
      {
        full:   object.logo.url,
        medium: object.logo.medium.url,
        thumb:  object.logo.thumbnail.url
      }
    else
      nil
    end
  end

  has_many :streams
end
