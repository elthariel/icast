class Api::StationsController < Api::BaseController
  resource_description do
    short 'Stations'
    formats ['json']

    description <<-EOS

### Introduction

This resource is the main part of this API. It represents an (Internet
Radio/Video) Station with it's associated informations and streaming
services.

Using our API, you can register you own station or suggest content and
details for existing stations, improving your service :)

### Example data

    {
      "station": {
        "id": 4499,
        "slug": "ebert-llc-radio",
        "name": "Ebert LLC Radio",
        "slogan": "Ze Bestest Unicorn Radio",
        "country": "fr",
        "language": "fr",
        "current": {
         },
        "streams": [
          {
            "uri": "http://dubuque.net/stream797.webm",
            "video": "false",
            "mime": "audio/vorbis",
            "bitrate": 64,
            "samplerate": null,
            "channels": 2
          }
        ],
        "details": {
          "id": 10,
          "station_id": 4499,
          "state": null,
          "city": "Paris",
          "website": "http://www.choucroute.name",
          "email": "zoie@jakubowski.biz",
          "twitter": @twitter_account,
          "phone": null,
          "logo": {
            "url": null
          },
          "description": "This is a long description of the radio",
          "lineup": "0h00 - 2h30 : Super Program 1\\n2h30 - 13h: Morning Super Program'\\n13h00-24h00: Random music from Space\\n",
          "created_at": "2014-01-14T10:30:04.582Z",
          "updated_at": "2014-01-14T10:30:04.582Z"
        }
      }
    }

### Access Control

There's currently 3 ways of using this API resource: Read-only, Authenticated,
and as a Radio Owner.

#### Read-only

If you don't have an account on our service, you can use this API read-only.
With this access level, you'll only be able to GET /stations and GET
/stations/:id

#### Authenticated

As an authenticated user, you'll be able to suggest new stations, details and to
register your own station.

#### Station Owner

As a station owner, you can update every details of your own radio station as
well as deleting it (don't leave us please, we like you !)

    EOS
  end

  include Paginatable
  include ScopedCaching
  caching_scope :user, [:current_user, :email]
  caching_scope :page, :page,       item: false
  caching_scope :per,  :page_size,  item: false

  respond_to :json
  before_action :authenticate_user!, only: [:create, :update, :destroy, :suggest, :like]
  before_action :load_station, only: [:show, :update, :destroy, :suggest, :like]

  api :GET, '/stations', 'List the stations'
  param :page, Fixnum, desc: "The number of the page to return"
  param :page_size, Fixnum, desc: "The size of the page to return, by default page_size is 20. Must be between 1 and 100"
  def index
    @stations = Station.all.includes(:streams)
      .by_popularity
      .page(page)
      .per(page_size)

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
    @station.details.origin = 'api'
    @station.user = current_user

    if @station.save
      render status: :ok, json: {id: @station.id, slug: @station.slug}
    else
      render status: :unprocessable_entity, json: @station.errors.full_message
    end
  end

  api :PATCH, '/stations/:id(.format)', 'Update an existing station'
  param :id, [Fixnum, String], desc: 'A unique identifier for the station, either numerical or the slug'
  param :station, String, desc: <<-EOS
    A JSON representation of the modified station, see POST /stations for format
    description. You can omit fields that have not changed
  EOS

  def update
    authorize_action_for @station

    if @station.update_attributes(station_params)
      show
    else
      render status: :unprocessable_entity, json: @station.errors.full_message
    end
  end

  api :PATCH, '/stations/:id/suggest(.format)', "Suggest modifications of a station"
  param :id, [Fixnum, String], required: true,
    desc: 'A unique identifier for the station, either numerical or the slug'
  param :station, Hash, required: true,
    desc: 'A JSON representation of the modified station, see POST /stations for details'
  description <<-EOS
  ### Return Value

  This API call returns an empty response with a 201 status on success, 422 otherwise

  EOS
  def suggest
    @contrib = @station.contributions.build(user: current_user, data: station_params)

    if @contrib.save
      render status: :created, nothing: true
    else
      render status: :unprocessable_entity, nothing: true
    end
  end

  api :DELETE, '/stations/:id(.format)', 'Removes the station from the directory'
  param :id, [Fixnum, String], required: true,
    desc: 'A unique identifier for the station, either numerical or the slug'
  def destroy
    authorize_action_for @station

    @action.destroy
    render status: :ok, nothing: true
  end


  api :POST, '/stations/:id/like(.format)', "Upvotes/Favorites this stations"
  param :id, [Fixnum, String], required: true,
    desc: 'A unique identifier for the station, either numerical or the slug'
  desc <<-DESC
  Cast an upvote on this station on behalf of the currently
  logged user'. It will be used in the future to handle favorites stations as
  well as to sort station by popularity.

  This is an authenticated call.
  DESC
  def like
    if !current_user.voted_for? @station and current_user.likes @station
      render nothing: true
    else
      render status: :forbidden, json: {errors: ['Already voted or unexpected error']}
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

  def station_params
    params.require(:station).permit(:slug, :name, :slogan, :country, :language, :logo, :genre_list,
      streams_attributes: [:id, :uri, :video, :mime, :bitrate, :samplerate, :channels, :width, :height, :framerate, :_delete],
      details_attributes: [:state, :city, :website, :email, :twitter, :phone, :description, :lineup],
      base64_logo: [:base64, :filename, :content_type])
  end
end
