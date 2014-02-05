class AngularController < ApplicationController
  def index
  end

  def show
    render params[:view]
  end
end
