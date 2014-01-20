require 'spec_helper'
require 'base64'

describe 'Station' do
  include_context 'authenticated'

  let (:station_attr) do
    attributes = FactoryGirl.attributes_for :station, logo: nil
    attributes['details_attributes'] = FactoryGirl.attributes_for :station_details
    attributes
  end

  let (:filepath)     { Rails.root.join('spec', 'fixtures', 'logo.png') }
  let (:fileupload)   { Rack::Test::UploadedFile.new(filepath, 'image/png') }
  let (:base64upload) do
    {
      base64:         Base64.encode64(File.open(filepath).read),
      filename:       'test.png',
      content_type:   'image/png'
    }
  end

  describe 'POST /stations.json' do
    it "works !" do
      expect do
        post api_stations_path, station: station_attr
      end.to change { Station.count }.by(1)
    end

    it "Handles Logo upload" do
      station_attr[:logo] = fileupload
      expect do
        post api_stations_path, station: station_attr
      end.to change { Station.count }.by(1)
      expect(File.exists? Station.last.logo.path).to be_true
    end

    it "Handles Base64 Logo upload" do
      station_attr[:base64_logo] = base64upload
      expect do
        post api_stations_path, station: station_attr
      end.to change { Station.count }.by(1)
      expect(File.exists? Station.last.logo.path).to be_true
    end
  end
end
