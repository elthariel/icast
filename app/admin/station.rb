ActiveAdmin.register Station do
  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  permit_params :name, :slug, :slogan, :country, :language, :genre_list, :logo,
    details_attributes: [:id, :state, :city, :website, :email, :twitter, :phone, :description, :lineup],
    streams_attributes: [:id, :uri, :mime, :video, :bitrate, :samplerate, :width, :height, :framerate, :_destroy]

  form do |f|
    f.inputs 'Main' do
      f.input :name
      f.input :slug
      f.input :slogan
      f.input :logo, as: :file
      f.input :country, as: :string #FIXME Use country-select gem
      f.input :language
      f.input :genre_list
      f.input :longitude
      f.input :latitude
    end

    f.inputs "Details", for: [:details, f.object.details || f.object.build_details] do |details|
      details.input :state
      details.input :city
      details.input :website
      details.input :email
      details.input :twitter
      details.input :phone
      details.input :description
      details.input :lineup
    end

    f.inputs "Streams" do
      f.has_many :streams, allow_destroy: true do |sf|
        sf.inputs do
          sf.input :uri
          sf.input :mime
          sf.input :bitrate
          sf.input :video, as: :select
          sf.input :channels
          sf.input :framerate
          sf.input :width
          sf.input :height
        end
      end
    end

    f.actions
  end
end
