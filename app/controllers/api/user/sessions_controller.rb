class Api::User::SessionsController < Api::BaseController
  respond_to :json

  resource_description do
    short 'User Session'
    formats ['json']

    description <<-EOS

    ### Intro

    A UserSession represents a logged-in user on our system. One can create a
    user session using an email/password couple previously registered and confirmed.

    ### Login

    To login, you have to create a user session using POST /user/sessions.

    This method return a session cookie called '_radioxide_session', which MUST be provided
    to subsequent requests for these requests to be authenticated

    ### Logout

    To logout, you have to delete your session using DELETE /user/sessions/current. The
    session cookie is now invalid

    ### Am i signed in ?

    To find out, issue a GET /user/sessions/current while providing your
    _radioxide_session cookie. If you get a 200, you're logged in, if you get a
    403, you're not.

    EOS
  end

  api :POST, '/user/sessions(.format)', 'Create a session | Login on Radioxide API'
  param :user_session, Hash, desc: 'A JSON hash containing two keys: email and password'
  description <<-EOS
  ### Example
      {
        'user_session': {
          email: 'my-super-email@provider.fr',
          password: 'my-password'
        }
      }
  EOS
  def create
    user = User.find_for_database_authentication(email: user_session_params[:email])

    if user and user.valid_password?(user_session_params[:password])
      sign_in(:user, user)
      render json: user
    else
      invalid_login_attempt
    end
  end

  api :DELETE, '/user/sessions/current(.format)', 'Delete the current session | Log off radioxide api'
  def destroy
    if user_signed_in?
      sign_out(current_user)
    end
    render status: :ok, nothing: true
  end

  api :GET, '/user/sessions/current(.format)', 'Returns the current logged-in user.'
  description "This is a convenience method to know if you're connected or not"
  def show
    puts current_user
    if user_signed_in?
      render status: :ok, json: current_user
    else
      render status: :unauthorized, nothing: true
    end
  end

  protected
  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end

  def invalid_login_attempt
    warden.custom_failure!
    render status: :unauthorized, nothing: true
  end
end
