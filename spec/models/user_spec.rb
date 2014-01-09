require 'spec_helper'

describe 'User' do
  describe "Role" do
    describe "User" do
      subject { FactoryGirl.create :user }
      it "is not root" do
        expect(subject.root?).to be_false
      end
      it "is not a moderator" do
        expect(subject.moderator?).to be_false
      end
    end

    describe "Root" do
      subject { FactoryGirl.create :user_root }
      it "is root" do
        expect(subject.root?).to be_true
      end
      it "is not a moderator" do
        expect(subject.moderator?).to be_false
      end
      it "is not a default user" do
        expect(subject.default?).to be_false
      end
    end
  end
end
