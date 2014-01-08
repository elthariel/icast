require 'spec_helper'

describe StreamUri do
  subject { FactoryGirl.create(:stream).stream_uris.first }

  describe "Validations" do
    it 'require a well formatted uri' do
      subject.uri = 'http!!test /fails'
      expect(subject.save).to be_false

      subject.uri = 'ftp://test.fr'
      expect(subject.save).to be_false

      subject.uri = 'http://this-is-a-valid/test.stream'
      expect(subject.save).to be_true
    end
  end
end
