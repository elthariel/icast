class Api::StationsController < Api::BaseController
  resource_description do
    short 'Stations'
    formats ['json', 'm3u', 'pls']

    description <<-EOS

    EOS
  end
  before_filter :load_station, only: [:show]

  api :GET, '/stations'
  def index
    render json: Station.all.includes(:streams)
  end



  api :GET, '/stations/:id(.format)' , 'Get Station\'s detailed informations or playlist'
  param :id, [String, Fixnum], required: true,
    desc: 'Unique identifier of the station, can be the unique id or a slug representing it'
  description <<-EOS
    ### As JSON

    When requested as a json, this method will return the detailed informations of the stations

    ### As Playlist

    When requested as an m3u/pls file, this method will return an m3u/pls playlist file suitable
    for a playler like VLC or others.

    Example: `vlc http://radioxi.de/api/1/stations/1.m3u`

  EOS
  def show
    respond_with do |format|
      format.json { render json: @station, serializer: DetailedStationSerializer }
      format.m3u
      format.pls
    end
  end

  protected
  def load_station
    model = Station.includes(:streams, :details)
    begin
      @station = model.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @station = model.find(params[:id])
    end
  end
end
