require 'spec_helper'

describe "Contributions" do
  include_context 'authenticated'

  let (:station)  { FactoryGirl.create :station }
  let (:contrib1) { FactoryGirl.create :contribution, user: user, contributable: station}
  let (:contrib2) { FactoryGirl.create :contribution, user: user, contributable: station}
  let (:contrib3) { FactoryGirl.create :contribution_new_content, user: user}
  let (:new_contrib1) { FactoryGirl.attributes_for :contribution, contributable_id: station.id }
  let (:new_contrib2) { FactoryGirl.attributes_for :contribution_new_content }

  describe "GET /contributions" do
    it "works!", :show_in_doc do
      contrib1 and contrib2 and contrib3
      get api_contributions_path

      expect(JSON.parse(response.body)).to be_a_kind_of(Hash)
      response.status.should be(200)
    end

    it "returns JSON of current_user contributions" do
      ids = [contrib1.id, contrib2.id, contrib3.id]
      get api_contributions_path

      contributions = JSON.parse(response.body)
      expect(contributions['contributions'].length).to be(3)
      expect(contributions['contributions'].map{|c| c['id']}.sort).to eq(ids.sort)
    end
  end

  describe "POST /contributions" do
    it 'creates a new contribution', :show_in_doc do
      [new_contrib1, new_contrib2].each {|c| c.delete :user}

      expect { post api_contributions_path, contribution: new_contrib2 }
        .to change { Contribution.count }.by(1)
      expect { post api_contributions_path, contribution: new_contrib1 }
        .to change { Contribution.count }.by(1)
    end
  end

  describe "PATCH /contributions/:id(.format)" do
    it 'updates existing Contribution of current_user', :show_in_doc do
      new_name = 'Another name'
      attributes = contrib1.attributes
      attributes['data']['name'] = new_name

      patch api_contribution_path(contrib1), contribution: attributes
      expect(response.status).to be(200)
      expect(contrib1.reload.data['name']).to eq(new_name)
    end
  end

  describe "DELETE /contributions/:id(.format)" do
    it "deletes the requested contribution", :show_in_doc do
      delete api_contribution_path(contrib1)

      expect(response.status).to be(200)
      expect{Contribution.find(contrib1.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
