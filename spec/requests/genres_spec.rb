require 'spec_helper'

describe 'GenresController' do
  describe "GET /genres.json" do
    it 'works !', :show_in_doc do
      get api_genres_path
      response.status.should be(200)

      json = JSON.parse(response.body).with_indifferent_access
      expect(json).to have_key(:genres)
      expect(json[:genres].first).to be_a_kind_of(Array)
    end
  end
  describe "GET /genres/popular.json" do
    it 'works !', :show_in_doc do
      get popular_api_genres_path
      response.status.should be(200)

      json = JSON.parse(response.body).with_indifferent_access
      expect(json).to have_key(:genres)
      expect(json[:genres]).to be_a_kind_of(Array)
    end
  end
end
