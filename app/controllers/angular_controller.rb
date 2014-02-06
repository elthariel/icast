class AngularController < ApplicationController
  def index
  end

  def show
    template = render_to_string params[:view], layout: false
    render text: template
    #render partial: params[:view], layout: nil
  end
end
