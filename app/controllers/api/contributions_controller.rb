class Api::ContributionsController < Api::BaseController
  resource_description do
    short "User Contributed Content"
    formats ['json']
    description <<-EOS

iCast is a collaborative Internet Radio/Video Station database. All of its
content is community created and reviewed and is (will be) accessible under a
CC-BY-SA . This API resource allows you to suggest new content and keep track of
your past/current contributions status.

Theses calls [requires authentication](/api/doc/1.0/sessions)

    EOS

    error code: 401, desc: 'Not Authenticated'
  end

  before_action :authenticate_user!
  before_action :set_contribution, only: [:show, :update, :destroy]

  api :GET, '/contributions(.format)', 'Get a list of you own contributions'
  def index
    @contributions = current_user.contributions
    render json: @contributions
  end

  api :POST, '/contributions(.format)', 'Contribute new content (thank you!)'
  param :contribution, Hash, required: true
  param 'contribution[contributable_type]', String, "The type of object contributed, only Station is supported now", required: true
  param 'contribution[contributable_id]', Fixnum, "The id of the object contributed to, or empty if you are submitting new content (new Station)"
  param 'contribution[data]', Hash, "The JSON representation of the object you want to contribute with all the unchanged fields removeded. The format is the same that for POST /stations.json", required: true
  see "stations#create"
  error code: 422, desc: "Doesn't pass validation (probably a missing field, wrong formatted field or an invalid id"
  description <<-DESC

  Submits a contribution. The contribution will be in a queue to be moderated
  before it is actually applied on our database. Using this API, you can
  contribute new content or suggest an update to existing content.

  The parameters to this call can be split into two parts :
    * Contribution system specific parameters
      * contributable_type (Station)
      * contributable_id
    * Actual contributed data.
      * data

  ### Contributed data format

  The format for the data depends on the contributable_type. For the currently
  only supported 'Station' type, the data format is the very same that for
  [Station#create](/api/doc/1.0/stations/create.html).

  To contribute a new station, you have to provide all the required fields for a
  station for the contribution to be valid. If you submit a content update (ie
  contributable_id provided), you can include only the fields you want to update

  We use rails nested attributes support to edit station's streams and details,
  see [the relevant rails documentation](http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html)

  DESC
  example <<-EXAMPLE
  POST /api/1/contributions.json
  {
    "contribution": {
      "contributable_type": "Station",
      "contributable_id": "42",
      "data": {
        "slug": "my_better_slug",
        "slogan": "The bestest radio",
        "streams_attributes": [
          {
            "id": "42",
            "_destroy": "1",
          },
          {
            "id": "43",
            "channels": "2"
          },
          {
            "uri": "http://asdasdas",
            "mime": "audio/ogg",
            "bitrate": "256"
          }
        ],
        "details_attributes": {
          "website": "http://www.new-website.com"
        }
      }
    }
  }
  201
  EXAMPLE
  def create
    @contribution = Contribution.new(contribution_params)
    @contribution.user = current_user

    if @contribution.save
      render status: :created, json: @contributions
    else
      render json: @contribution.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contributions/1.json
  api :PATCH, '/contributions/:id', "Update one of your contribution. (Useless if the contribution has already been applied)"
  param :id, Fixnum, "The id of the contribution to update", required: true
  param :contribution, Hash, "The updated contribution, format is the same that for creation"
  error code: 422, desc: 'The validation failed'
  see "contributions#create"
  def update
    if @contribution.update(contribution_params)
      render nothing: true, status: :ok
    else
      render json: @contribution.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contributions/1.json
  api :DELETE, '/contributions/:id', "Delete one of your contribution. (Useless if the contribution has already been applied)"
  param :id, Fixnum, "The id of the contribution to delete", required: true
  def destroy
    @contribution.destroy
    render status: :ok, nothing: true
  end

  api :GET, '/contributions/on_my_stations(.format)', 'Get the list of pending contributions to my owned Stations'
  see "contributions#index"
  def on_my_stations
    @contributions = current_user.stations.where(applied_at: nil)
      .includes(:contributions).map { |s| s.contributions }.flatten

    render json: @contributions
  end

  api :POST, '/contributions/:id/apply(.format)', "Apply a contribution on one of my stations"
  param :id, Fixnum, 'The id of the contribution to apply', required: true
  error code: 401, desc: 'You are not authenticated or you are not allowed to apply this contribution (new contribution or you are not the owner of the concerned station)'
  def apply
    @contribution = Contribution.find(params[:id])
    authorize_action_for @contribution

    @contribution.apply!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = current_user.contributions.find(params[:id])
      authorize_action_for @contribution
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      p = params.require(:contribution)
        .permit(:contributable_type, :contributable_id, data: [
          :name, :slug, :slogan, :country, :language, current: [:artist, :title, :genre],
          streams_attributes: [:id, :uri, :video, :mime, :bitrate, :samplerate, :channel, :width, :height, :_delete],
          details_attrinites: [:state, :city, :website, :email, :twitter, :phone, :logo, :description, :lineup]
          ])
    end
end
