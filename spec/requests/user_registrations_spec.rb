require 'spec_helper'

describe 'Api::User:RegistrationController' do
  let(:valid_user)   { { email: 'test@test.fr', password: 'qweasd42', password_confirmation: 'qweasd42' } }
  let(:invalid_user) { { email: 'test@test.fr', password: 'qweasd42', password_confirmation: 'qweasd' } }

  describe "POST /user/registrations.json" do
    it 'creates a new User' do
      post api_user_registrations_path, user_registration: valid_user

      expect(response.status).to be(201)
      expect(User.where(email: valid_user[:email]).first).not_to be_nil
    end

    it 'returns \'UnprocessableEntity\' when validation fails' do
      post api_user_registrations_path, user_registration: invalid_user

      expect(response.status).to be(422)
    end


    it 'allows to login with the created user' do
      # Create the user
      post api_user_registrations_path, user_registration: valid_user

      # Confirm it directly in DB.
      User.where(email: valid_user[:email]).first.confirm!

      # Login with newly created/confirmed user
      post api_user_sessions_path, user_session: {email: valid_user[:email], password: valid_user[:password]}
      get api_user_session_path(:current)

      expect(response.status).to be(200)
    end
  end

  describe "DELETE /user/registrations/current.json" do
    it 'deletes the current user' do
      # Create the user
      post api_user_registrations_path, user_registration: valid_user

      # Confirm it directly in DB.
      User.where(email: valid_user[:email]).first.confirm!

      # Login with newly created/confirmed user
      post api_user_sessions_path, user_session: {email: valid_user[:email], password: valid_user[:password]}

      # Now deletes the user
      delete api_user_registration_path(:current)

      expect(response.status).to be(200)
      expect(User.where(email: valid_user[:email]).first).to be_nil
    end

    it "returns :not_found (404) if not logged_in" do
      # Now deletes the user
      delete api_user_registration_path(:current)

      expect(response.status).to be(404)
    end
  end
end
