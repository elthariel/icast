require 'spec_helper'

describe 'Icecast compatibility API' do
  let (:station) do
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

  describe "#add" do
    it 'creates a Station, a StationDetails and a Stream' do
      expect {post '/api/1/icecast', station.merge(action: 'add')}
        .to(change { Station.count }.by(1))
    end
  end

  describe "#remove" do
    it 'removes the Station' do
      post '/api/1/icecast', station.merge(action: 'add')
      expect { post '/api/1/icecast', action: 'remove', sid: 'my-super-name' }
        .to(change { Station.count }.by(-1))
    end
  end
end
