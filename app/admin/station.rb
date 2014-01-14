ActiveAdmin.register Station do
  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  permit_params :name, :slug, :country, :language, :genre_list,
    details_attributes: [:state, :city, :website, :email, :twitter, :phone, :logo, :description, :lineup],
    streams_attributes: [:uri, :mime, :video, :bitrate, :samplerate, :width, :height, :framerate, :_destroy]

  form do |f|
    f.inputs 'Main' do
      f.input :name
      f.input :slug
      f.input :slogan
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
      details.input :logo, as: :file
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

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

end
