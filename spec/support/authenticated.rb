shared_context 'authenticated' do
  let (:user) { FactoryGirl.create :confirmed_user }

  def authenticate!
    post api_user_sessions_path, user_session: {email: user.email, password: user.password}
  end

  before do
    authenticate!
  end
end
