class Api::StationsController < Api::BaseController
  before_filter :load_station, only: [:show]

  def index
    render json: Station.all.includes(:streams).limit(10)
  end

  def show
    render json: @station, serializer: DetailedStationSerializer
  end

  protected
  def load_station
    begin
      @station = Station.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      @station = Station.find(params[:id])
    end
  end
end
