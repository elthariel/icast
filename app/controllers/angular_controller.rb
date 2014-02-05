class AngularController < ApplicatioController
  def index
  end

  def show
    render params[:view]
  end
end
