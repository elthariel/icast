class Api::ContributionsController < Api::BaseController
  resource_description do
    short "User Contributed Content"
    formats ['json']
    description <<-EOS

### Introduction

Radioxide is a collaboration Internet Radio/Video Station database. All of its
content is community created and reviewed and is accessible under an OpenSource
license (to be determined lated). This API resource allows you to suggest new
content and keep track of your past/current contributions status.

There calls needs authentication.

    EOS
  end

  before_action :authenticate_user!
  before_action :set_contribution, only: [:show, :update, :destroy]

  api :GET, '/contributions(.format)', 'Get a list of you own contributions'
  def index
    @contributions = current_user.contributions
    render json: @contributions
  end

  #api :GET, '/contributions(.format)', 'Get a list of you own contributions'
  #def show
  #end


  api :POST, '/contributions(.format)', 'Contribute new content (thank you!)'
  param :contribution, Hash, required: true
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
  def update
    if @contribution.update(contribution_params)
      render nothing: true, status: :ok
    else
      render json: @contribution.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    render status: :ok, nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = current_user.contributions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      p = params.require(:contribution)
        .permit(:contributable_type, :contributable_id, data: [
          :name, :slug, :slogan, :country, :language, current: [:artist, :title, :genre],
          streams_attributes: [:uri, :video, :mime, :bitrate, :samplerate, :channel, :width, :height],
          details_attrinites: [:state, :city, :website, :email, :twitter, :phone, :logo, :description, :lineup]
          ])
    end
end
