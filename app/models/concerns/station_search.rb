module StationSearch
  extend ActiveSupport::Concern

  def elastic_location
    { lat: latitude, lon: longitude }
  end

  included do
    include Tire::Model::Search
    include Tire::Model::Callbacks

    mapping do
      indexes :id,                index: :not_analyzed
      indexes :slug,              index: :not_analyzed
      indexes :name,              analyzer: :simple
      indexes :slogan
      indexes :country,           index: :not_analyzed
      indexes :language,          index: :not_analyzed
      indexes :genres,                                      as: 'genre_list'
      #indexes :tags,              analyzer: :simple,        as: 'tag_list'
      indexes :location,          type: :geo_point,         as: 'elastic_location'
      indexes 'details.state',                              as: 'details.state'
      indexes 'details.city',                               as: 'details.city'
      # FIXME Check for ngram analyzer and use if it's cool
      indexes 'details.website',  index: :not_analyzed,     as: 'details.website'
      indexes 'details.twitter',  index: :not_analyzed,     as: 'details.twitter'
      indexes 'details.email',    index: :not_analyzed,     as: 'details.email'
      indexes 'details.phone',    index: :not_analyzed,     as: 'details.phone'
      indexes 'details.lineup',                             as: 'details.lineup'
      indexes 'details.description',                        as: 'details.description'
    end
  end

  module ClassMethods
    # This method expect an array of genre
    def by_genre(genre_list)
    end
    def search(q, opts = {})
      tire_options = {
        page: opts[:page] || 1,
        size: opts[:page_size] || 20,
        load: true
      }

      self.tire.search(tire_options) do
        if q.present?
          query do
            string q
          end
        end

        if opts[:genres].present?
          filter :terms, genres: opts[:genres], execution: 'and'
        end
      end
    end
  end
end
