require 'spec_helper'

describe 'Api::User::Passwords' do
  let (:user) { FactoryGirl.create :confirmed_user }
  let (:valid_params) do
    {
      user_password: {
        old_password: user.password,
        password: 'new_password',
        password_confirmation: 'new_password'
      }
    }
  end

  describe "POST /user/passwords" do
    it "changes the password" do
      post api_user_sessions_path, user_session: {email: user.email, password: user.password}
      post api_user_passwords_path, valid_params

      expect(response.status).to be(200)
      delete api_user_session_path(:current)
      expect(response.status).to be(200)
      post api_user_sessions_path, user_session: {email: user.email, password: valid_params[:user_password][:password]}
      expect(response.status).to be(200)
    end
  end
end
