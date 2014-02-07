class Api::IcecastController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :load_station_and_check_action

  # Parameters: {"sn"=>"my super name !", "genre"=>"caca", "cpswd"=>"", "desc"=>"my desc",
  #   "url"=>"", "listenurl"=>"http://still:8042/test", "type"=>"application/ogg",
  #   "stype"=>"Vorbis", "b"=>"96", "\r\n"=>nil}
  def add
    slug = params[:sn].parameterize

    @station = Station.new(
      name: params[:sn],
      slug: slug,
      slogan: params[:desc],
      genre_list: [params[:genre]],
      details_attributes: {
        website: params[:url]
      }
      )

    if @station.save
      @station.streams.create! uri: params[:listenurl], bitrate: params[:b],
        mime: params[:type]

      response.headers['SID'] = @station.slug
      response.headers['TouchFreq'] = '10'
      iceast_success 'Station successfully created'
    else
      icecast_error @station.errors.full_messages.inspect
    end

    dummy_render
  end

  def touch
    iceast_success "Unimplemented"
    dummy_render
  end

  def remove
    @station.destroy
    iceast_success "Destroyed"
    dummy_render
  end

  protected
  def iceast_success(msg = 'Success')
    response.headers['YPResponse'] = '1'
    response.headers['YPMessage'] = msg
  end

  def icecast_error(msg = 'Error')
    Rails.logger.warn msg
    response.headers['YPResponse'] = '0'
    response.headers['YPMessage'] = msg
  end

  def load_station_and_check_action
    begin
      if ['touch', 'remove'].include? params[:action]
        @station = Station.friendly.find(params[:sid])
      end
    rescue ActiveRecord::RecordNotFound
      icecast_error "Station not foud"
    end
  end

  def dummy_render
    render nothing: true, status: :ok
  end
end
