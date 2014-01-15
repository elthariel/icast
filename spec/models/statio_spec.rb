require 'spec_helper'

describe Station do
  subject { FactoryGirl.create :station }

  describe "#listeners" do
    it "has a 0 default value" do
      expect(subject.listeners).to eq(0)
    end
    it "returns previously stored value" do
      subject.listeners = 42
      expect(subject.listeners).to eq(42)
    end
  end

  describe "#listeners=" do
    it 'converts the value to an int' do
      subject.listeners = "Test"
      expect(subject.listeners).to eq(0)
      subject.listeners = "450"
      expect(subject.listeners).to eq(450)
      subject.listeners = 42
      expect(subject.listeners).to eq(42)
    end

    it 'behaves like an AR attribute' do
      subject.update_attributes(listeners: 84)
      expect(subject.listeners).to eq(84)
    end
  end

  describe "#metadata" do
    it "behaves like an AR attribute" do
      subject.update_attributes(metadata: {song: 'MySong'})

      expect(subject.metadata[:song]).to eq('MySong')
    end

    it "provides delegation on classic metadata" do
      subject.update_attributes(metadata: {artist: 'Artyst', title: 'program'})
      expect(subject.current_artist).to eq('Artyst')
      expect(subject.current_title).to eq('program')
    end
  end

  describe "Validations" do
    it 'requires a minimum length for name' do
      subject.name = 'r'
      expect(subject.save).to be_false

      subject.name = 'this is a very long and cool name for a radio'
      expect(subject.save).to be_true
    end
  end

  describe "GeoCoding" do
    subject { FactoryGirl.create :station, country: 'fr' }

    describe "#geocode" do
      it "is called if city field changes" do
        expect(subject).to receive(:geocode)
        subject.details.city = 'Paris'
        subject.save
      end

      it 'sets latitude and longitude on parent Station' do
        expect(subject.longitude).not_to be_present
        expect(subject.latitude).not_to be_present
        subject.details.city = 'Paris'
        subject.save
        expect(subject.longitude).to be_present
        expect(subject.latitude).to be_present
      end
    end
  end
end
