require 'spec_helper'

describe 'StationSearch' do
  let (:stations) do
    stations = (0..10).to_a.map {
      FactoryGirl.create :station
    }

    stations.each { |s| s.tire.update_index }
    Station.tire.index.refresh
    stations
  end
  before(:each) { Station.tire.index.delete }
  after(:all)  { Station.tire.index.delete }

  describe 'GET /stations/local.json' do
    it "works!", :show_in_doc do
      expect(stations)
      get local_api_stations_path

      response.status.should be(200)
    end
  end

  describe 'GET /stations/country/:code.json' do
    it "works!", :show_in_doc do
      expect(stations)
      get country_api_stations_path(country_code: 'fr')

      response.status.should be(200)
    end
  end

  describe 'GET /stations/language/:lang.json' do
    it "works!", :show_in_doc do
      get language_api_stations_path(language: 'fr')

      response.status.should be(200)
    end
  end

  describe 'GET /stations/genre/:genre.json' do
    it "works!", :show_in_doc do
      expect(stations)
      get genre_api_stations_path(genres: 'choucroute,rock')

      response.status.should be(200)
    end
  end

  describe "GET /stations/search?q=:query" do
    it 'works !', :show_in_doc do
      expect(stations)
      get search_api_stations_path(q: 'maxime')

      response.status.should be(200)
    end
  end
end
