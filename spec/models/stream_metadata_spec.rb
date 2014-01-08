require 'spec_helper'

describe StreamMetadata do
  subject { FactoryGirl.create(:stream).metadata}
  describe "catch all accessors" do
    it 'supports #anything=' do
      subject.mymeta = 'test'
      expect(subject.mymeta).to eq('test')
    end

    it 'raises NoMethodError on ! and ? methods' do
      expect { subject.fail! }.to raise_error(NoMethodError)
    end
  end
end
