class Api::ContributionsController < Api::BaseController
  before_action :authenticate_user!
  before_action :set_contribution, only: [:show, :update, :destroy]

  # GET /contributions.json
  def index
    @contributions = current_user.contributions
  end

  # GET /contributions/1.json
  def show
  end


  # POST /contributions.json
  def create
    @contribution = Contribution.new(contribution_params)

    respond_to do |format|
      if @contribution.save
        format.json { render action: 'show', status: :created, location: @contribution }
      else
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.json { head :no_content }
      else
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = current_user.contributions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      params.require(:contribution).permit(:user_id, :contribution_type, :contribution_id, :data)
    end
end
