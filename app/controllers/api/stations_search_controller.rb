class Api::StationsSearchController < Api::BaseController
  resource_description do
    short    'Station search'
    formats  ['json']

    description <<-EOS
    ### Introduction

    Handy API calls to search for specific stations

    EOS
  end

  include GeocodeRequest

  before_action :geocode_request!, only: [:local]

  respond_to :json

  def local
    @stations = Station.where(country: @geoip['country_code2'].downcase)
      .page(params[:page] || 0)
    render_stations
  end

  def country
    if params[:country_code].empty? or params[:country_code].length != 2
      render status: :not_found, nothing: true
    else
      @stations = Station.where(country: params[:country_code].downcase)
        .page(params[:page] || 0)
      render_stations
    end
  end

  def language
    if params[:language].empty? or params[:language].length != 2
      render status: :not_found, nothing: true
    else
      @stations = Station.where(language: params[:language].downcase)
        .page(params[:page] || 0)
      render_stations
    end
  end

  protected
  def render_stations
    render json: @stations, serializer: KaminariSerializer, root: :stations
  end
end
