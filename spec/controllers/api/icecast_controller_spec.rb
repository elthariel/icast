require 'spec_helper'

describe Api::IcecastController do
  describe "add" do
    let (:params) do
      { "sn"          => "my super name !",
        "genre"       => "trance",
        "cpswd"       => "",
        "desc"        => "my desc",
        "url"         => "http://videolan.org",
        "listenurl"   => "http://still:8042/test",
        "type"        => "application/ogg",
        "stype"       => "Vorbis",
        "b"           => "96" }
    end

    it "creates a station" do
      expect {post :add, params}.to change{ Station.count }.by(1)

      station = assigns(:station)
      expect(station.streams.count).to eq(1)
      expect(station.streams.first.uri).to eq('http://still:8042/test')
      expect(station.details.website).to eq('http://videolan.org')
    end
  end
end
