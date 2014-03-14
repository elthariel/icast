class StationSerializer < CachedSerializer
  attributes :id, :slug, :name, :slogan, :country, :language, :current,
    :genre_list, :logo, :likes
  has_many :streams

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

  def likes
    object.cached_votes_up
  end
end
