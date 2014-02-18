ActiveAdmin.register Station do
  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  permit_params :name, :slug, :slogan, :country, :language, :genre_list, :logo,
    details_attributes: [:id, :state, :city, :website, :email, :twitter, :phone, :description, :lineup],
    streams_attributes: [:id, :uri, :mime, :video, :bitrate, :samplerate, :width, :height, :framerate, :_destroy]

  member_action :merge_other, method: :post do
    station = Station.find(params[:id])
    other_station = Station.find(params[:other_station_id])
    station.merge_other!(other_station)
    redirect_to admin_station_path(station)
  end

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

  show do |station|
    panel 'Main' do
      attributes_table_for station do
        row :id
        row :name
        row :slug
        row :slogan
        row :country
        row :language
        row :genre_list
        row :longitude
        row :latitude
      end
    end
    panel 'Details' do
      attributes_table_for station.details do
        row :origin
        row :state
        row :city
        row :website
        row :email
        row :twitter
        row :description
        row :lineup
      end
    end
    panel 'Streams' do
      table_for station.streams do
        column :id
        column :uri
        column :mime
        column :bitrate
        column :samplerate
        column :channels
        column :video
      end
    end

    panel 'Actions' do
      form method: :post, action: merge_other_admin_station_path(station.id) do |f|
        label 'Merge this other station into the current one', for: :other_id
        input type: :text, name: :other_station_id, placeholder: 'other_station_id'
        input type: :submit
      end
    end
  end
end
