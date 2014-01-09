require 'spec_helper'

describe 'Stream and Station Serializers' do
  let (:station)      { FactoryGirl.create :station }
  let (:stream)       { FactoryGirl.create :stream, video: false, station: station }

  describe 'StreamSerializer' do
    describe "#video" do
      subject { StreamSerializer.new stream }
      it 'return stringified boolean' do
        expect(subject.video).to eq('false')
      end
    end

    describe "#attributes" do
      subject { JSON.parse StreamSerializer.new(stream).to_json }

      it "removes video fields when audio-only" do
        expect(subject['stream'].keys.include? 'width').to be_false
        expect(subject['stream'].keys.include? 'height').to be_false
        expect(subject['stream'].keys.include? 'framerate').to be_false
      end
    end
  end

  describe "StationSerializer" do
    subject { StationSerializer.new(station) }
    it 'renders metadata as \'current\'' do
      station.metadata.artist = 'Elthariel'
      station.metadata.title  = 'Abstract Factory'

      hash = JSON.parse(subject.to_json)['station']
      expect(hash['current']['artist']).to eq(station.current_artist)
      expect(hash['current']['title']).to  eq(station.current_title)
    end
  end

  describe "DetailedStationSerializer" do
    let (:base)     { JSON.parse StationSerializer.new(station).to_json }
    let (:detailed) { JSON.parse DetailedStationSerializer.new(station).to_json }

    it "adds a details field" do
      expect(detailed['station'].keys - base['station'].keys).to eq(['details'])
    end
  end
end
