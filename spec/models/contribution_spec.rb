require 'spec_helper'

describe Contribution do
  let (:user)    { FactoryGirl.create :user }
  let (:station) { FactoryGirl.create :station, user: user }

  let (:content_update) { FactoryGirl.build :contribution, user: user, contributable: station }
  let (:new_content)    { FactoryGirl.build :contribution_new_content, user: user }

  let (:invalid_data)   { { language: 'too_long', slug: 'x' } }
  describe '#create' do
    it "allows to contribute new content (contributable_id = nil)" do
      expect(new_content.save).to be_true
      expect(new_content.new_content?).to be_true
    end

    it "allows to suggest change on existing content" do
      expect(content_update.save).to be_true
      expect(content_update.new_content?).to be_false
    end
  end

  describe "#contribution_valid?" do
    it 'reports contributable errors to Contribution#errors' do
      content_update.data = invalid_data
      content_update.valid?
      expect(content_update.errors.size).to eq(2)
    end
  end

  describe "#apply" do
    it 'updates applied_at field' do
      expect(new_content.applied_at).to be_nil
      new_content.apply
      expect(new_content.applied_at).to be_a_kind_of(Time)
    end

    it 'handle base64 serialized image for contribution to Station' do
      station = new_content.apply
      expect(File.exists? station.logo.path).to be_true
      expect(station.logo.path).to match(/redis\.png/)
    end
  end

  describe "#apply!" do
    it 'apply the contribution and save!' do
      content_update.apply!
      expect(station.name).to eq(content_update.data[:name])
    end

    it 'raises on validation error' do
      content_update.data = invalid_data
      expect { content_update.apply! }.to raise_error
    end

    it 'can create a new record' do
      new_record = new_content.apply!

      expect(new_record).not_to eq(station.id)
      expect(new_record.persisted?).to be_true
    end
  end
end
