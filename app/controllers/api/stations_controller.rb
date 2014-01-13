class Api::StationsController < Api::BaseController
  resource_description do
    short 'Stations'
    formats ['json']

    description <<-EOS

    EOS
  end

  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :load_station, only: [:show, :update, :destroy]

  api :GET, '/stations', 'List the stations'
  param :page, Fixnum, desc: "The number of the page to return"
  param :page_size, Fixnum, desc: "The size of the page to return, by default page_size is 20. Must be between 1 and 100"
  def index
    authorize_action_for Station

    @stations = Station.all.includes(:streams)
      .page(params[:page])
      .per(params[:page_size] || 20)

    render json: @stations, serializer: KaminariSerializer
  end


  api :GET, '/stations/:id(.format)' , 'Get Station\'s detailed informations or playlist'
  formats ['json', 'm3u', 'pls']
  description <<-EOS
    ### As JSON

    When requested as a json, this method will return the detailed informations of the stations

    ### As Playlist

    When requested as an m3u/pls file, this method will return an m3u/pls playlist file suitable
    for a playler like VLC or others.

    Example: `vlc http://radioxi.de/api/1/stations/1.m3u`

  EOS
  def show
    authorize_action_for @station

    respond_with do |format|
      format.json { render json: @station, serializer: DetailedStationSerializer }
      format.m3u
      format.pls
    end
  end

  api :POST, '/stations(.format)', 'Create a new station'
  param :station, String, required: true, desc: 'The JSON description of the station, see below'
  description <<-EOS
  ### JSON Example
      {
        "station": {
          "slug": "a-short-name",
          "name": "My Human Friendly Name",
          "slogan": "Ze Coolest Radio 3v3r",
          "country": "fr",
          "language": "fr",
          "streams_attributes": [
            {
              "uri": "http://my.stream.org:8100/my_stream",
              "video": "false",
              "mime": "video/webm",
              "bitrate": 48,
              "samplerate": 0,
              "channels": 0
            }
          ],
          "details_attributes": {
            "state": null,
            "city": null,
            "website": "http://www.gradydickens.org",
            "email": "stuart@nitzsche.biz",
            "twitter": null,
            "phone": null,
            "description": "Id corrupti nobis error ut. Amet non ut aut autem mollitia possimus. Unde architecto harum tempore enim. Rem rerum exercitationem numquam dolor. Est rerum magnam eligendi nostrum dicta.",
            "lineup": "At et eaque. Explicabo omnis quaerat libero iure eos."
          }
        }
      }
  EOS
  def create
    authorize_action_for Station

    @station = Station.new(station_params)

    if @station.save
      render status: :ok, json: {id: @station.id, slug: @station.slug}
    else
      render status: :unprocessable_entity, json: @station.errors.full_message
    end
  end

  api :PATCH, '/stations/:id(.format)', 'Update an existing station'
  param :id, [Fixnum, String], description: 'A unique identifier for the station, either numerical or the slug'
  param :station, String, description: 'A JSON representation of the modified station, see POST /stations for format description'
  def update
    authorize_action_for @station

    if @station.update_attributes(station_params)
      show
    else
      render status: :unprocessable_entity, json: @station.errors.full_message
    end
  end

  api :DELETE, '/stations/:id(.format)', 'Removes the station from the directory'
  param :id, [Fixnum, String], description: 'A unique identifier for the station, either numerical or the slug'
  def destroy
    authorize_action_for @station

    @action.destroy
    render status: :ok, nothing: true
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

  def station_params
    params.require(:station).permit(:slug, :name, :slogan, :country, :language,
      streams_attributes: [:uri, :video, :mime, :bitrate, :samplerate, :channels, :width, :height, :framerate],
      details_attributes: [:state, :city, :website, :email, :twitter, :phone, :description, :lineup])
  end
end
