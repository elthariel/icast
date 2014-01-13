require 'spec_helper'

describe 'Api::User::Passwords' do
  let (:user) { FactoryGirl.create :user }

  describe "POST /user/confirmations" do
    it 'doesn\'t tell you if email exists' do
      post api_user_confirmations_path, email: 'fake-email@ssdfsdfsdf.fr'
      expect(response.status).to be(201)

      post api_user_confirmations_path, email: user.email
      expect(response.status).to be(201)
    end
  end
end
