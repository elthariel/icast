class Api::StationsSearchController < Api::BaseController
  resource_description do
    short    'Station search'
    formats  ['json']

    param :page, Fixnum, 'The starting offset of results returned'
    param :page_size, Fixnum, 'The number of results to return per page'

    description <<-EOS
    ### Introduction

    Handy API calls to search for specifics stations

    EOS
  end

  include GeocodeRequest
  before_action :geocode_request!, only: [:local]

  include Paginatable
  include ScopedCaching
  caching_scope :page, :page
  caching_scope :per,  :page_size

  respond_to :json



  api :GET, '/stations/local(.format)', 'Returns a list of local station'
  description <<-EOS
  This API call uses the IP of the caller to determine a list of local stations
  and returns that list

  ### Returned data

  The format of the result is the same than GET /stations(.format) call.

  EOS
  def local
    @stations = Station.where(country: geoip['country_code2'].downcase)
      .by_popularity
      .page(params[:page] || 0)
      .per(params[:page_size] || 20)

    caching_scope :country, geoip['country_code2'], item: false
    render_stations
  end


  api :GET, '/stations/country/:country_code(.format)', 'Return a list of stations of the requested Country'
  param :country_code, String, "2 letters ISO3166 country code, or 'current'", required: true
  description <<-DESC
  Returns a list of stations for the country designated by the :country_code parameters.

  ### Current Country

  If the :country_code parameter is set to 'current', this method uses a
  geographical IP database to determine your country and then returns a list of
  station for this country

  ### Examples

      curl http://icast.lta.io/api/1/stations/country/it.json?page=3&page_size=2
      curl http://icast.lta.io/api/1/stations/country/current.json

  ### Returned data

  The format of the result is the same than GET /stations(.format) call.

  DESC
  def country
    # Provide a special alias for my IP's country
    if params[:country_code] == 'current'
      geocode_request!
      params[:country_code] = @geoip['country_code2'].downcase
    end

    if params[:country_code].empty? or params[:country_code].length != 2
      render status: :not_found, nothing: true
    else
      @stations = Station.where(country: params[:country_code].downcase)
        .page(params[:page] || 0).by_popularity

      caching_scope :country, params[:country_code2], item: false
      render_stations
    end
  end



  api :GET, '/stations/language/:language(.format)', 'Returns a list of :language speaking stations'
  param :language, String, "2 letters code for the language or \'browser\'", required: true
  description <<-DESC
  Returns a list of Station speaking the language specified by the :language param.

  ### Browser language

  If the :language parameter is set to 'browser', this method use the
  'HTTP_ACCEPT_LANGUAGE' http header to determine the requested language (we
  take the first language of the list).

  ### Examples

      curl http://icast.lta.io/api/1/stations/language/fr.json
      curl http://icast.lta.io/api/1/stations/language/browser.json?page=4&page_size=8

  ### Returned data

  The format of the result is the same than GET /stations(.format) call.

  DESC
  def language
    if params[:language] == 'browser'
      params[:language] = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end

    if params[:language].empty? or params[:language].length != 2
      render status: :not_found, nothing: true
    else
      @stations = Station.where(language: params[:language].downcase)
        .by_popularity
        .page(params[:page] || 0)
        .per(params[:page_size] || 20)

      caching_scope :lang, params[:language], item: false
      render_stations
    end
  end



  api :GET, 'stations/genre/:genre(.format)', 'Return a list of stations for the requested genre'
  param :genre, String, "The request genre name (eg. 'rock')", required: true
  description <<-DESC
  Returns a list of Station for the specified genre

  ### Examples

      curl http://icast.lta.io/api/1/stations/genre/rock,disco.json
      curl http://icast.lta.io/api/1/stations/language/news.json?page=42&page_size=23

  ### Returned data

  The format of the result is the same than GET /stations(.format) call.

  DESC
  def genre
    render status: :not_found if params[:genres].empty?

    caching_scope :genre, params[:genres], item: false

    params[:genres] = params[:genres].downcase.split(',')
    @stations = Station.search(params[:q], genres: params[:genres],
      page: params[:page], page_size: params[:page]
    )
    render_stations
  end

  api :GET, 'stations/search(.format)', 'Return a list of stations for the requested query string'
  param :q, String, "Some text to search for in our staion index", required: true
  description <<-DESC
  Returns a list of Station for the specified text. A full-text search is performed

  ### Examples

      curl http://icast.lta.io/api/1/stations/search.json?q=fr,disco,paris,news

  ### Returned data

  The format of the result is the same than GET /stations(.format) call.

  DESC
  def search
    render status: :not_found if params[:q].empty?

    @stations = Station.search(params[:q],
      page: params[:page], page_size: params[:page]
    )

    caching_scope :searchq, params[:q]
    render_stations
  end

  protected
  def render_stations
    render json: @stations, serializer: KaminariSerializer, root: :stations
  end
end
