require 'spec_helper'

describe "Api::User::UserSessions" do
  let (:user) { FactoryGirl.create :confirmed_user}

  describe "POST /user/sessions" do
    it "signs User in" do
      post api_user_sessions_path, user_session: {email: user.email, password: user.password}

      response.status.should be(200)
    end

    it 'sets a session cookie' do
      post api_user_sessions_path, user_session: {email: user.email, password: user.password}

      expect(response.cookies['_radioxide_session']).not_to be_nil
    end

    it 'returns a 401 on wrong password' do
      post api_user_sessions_path, user_session: {email: user.email, password: 'wrongpass'}

      response.status.should be(401)
    end
  end

  describe "GET /user/sessions/current" do
    it 'returns the current user' do
      post api_user_sessions_path, user_session: {email: user.email, password: user.password}
      get api_user_session_path(:current)

      expect(response.status).to be(200)
      expect(JSON.parse(response.body)['user']['email']).to eq(user.email)
    end

    it 'returns a 401 if the user is not logged in' do
      get api_user_session_path(:current)

      expect(response.status).to be(401)
    end
  end

  describe "DELETE /user/sessions/current" do
    it "signs User out" do
      post api_user_sessions_path, user_session: {email: user.email, password: user.password}
      delete api_user_session_path(:current)
      get api_user_session_path(:current)

      expect(response.status).to be(401)
    end
  end
end
