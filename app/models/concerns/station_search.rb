module StationSearch
  extend ActiveSupport::Concern

  def elastic_location
    { lat: latitude, lon: longitude }
  end

  included do
    include Tire::Model::Search
    include Tire::Model::Callbacks

    settings analysis: {
      filter: {
        url_ngram: {
          "type"     => "nGram",
          "max_gram" => 5,
          "min_gram" => 3
          }
        }
      },
      analyzer: {
        url_analyzer: {
          tokenizer:  :lowercase,
          filter:     [:stop, :url_ngram],
          type:       :custom
        }
      }

    mapping do
      indexes :id,                index: :not_analyzed
      indexes :slug,              index: :not_analyzed
      indexes :name,              analyzer: :simple
      indexes :slogan,            analyzer: :snowball
      indexes :country,           index: :not_analyzed
      indexes :language,          index: :not_analyzed
      indexes :genres,            analyzer: :simple,    as: 'genre_list'
      indexes :tags,              analyzer: :simple,    as: 'tag_list'
      indexes :location,          type: :geo_point,     as: 'elastic_location'
      indexes 'details.state',                          as: 'details.state'
      indexes 'details.city',                           as: 'details.city'
      indexes 'details.website',  analyzer: :url,       as: 'details.website'
      indexes 'details.twitter',  index: :not_analyzed, as: 'details.twitter'
      indexes 'details.email',    index: :not_analyzed, as: 'details.email'
      indexes 'details.phone',    index: :not_analyzed, as: 'details.phone'
      indexes 'details.lineup',   index: :not_analyzed, as: 'details.lineup'
      indexes 'details.description',  index: :not_analyzed, as: 'details.description'
    end
  end

  module ClassMethods
    # This method expect an array of genre
    def by_genre(genre_list)
    end
    def search(q, opts = {})
      tire_options = {
        page: opts[:page] || 1,
        size: opts[:page_size] || 20
      }

      self.tire.search(tire_options) do
        query do
          string q
        end
      end
    end
  end
end
