class Api::BaseController < ApplicationController
  respond_to :json

  # This is a ctach-all routes for OPTIONS request
  def options
    render nothing: true
  end
end
