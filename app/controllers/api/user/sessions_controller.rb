class Api::User::SessionsController < Api::BaseController
  respond_to :json

  def create
    user = User.find_for_database_authentication(email: user_session_params[:email])

    puts "User == #{user.email}"

    if user and user.valid_password?(user_session_params[:password])

      sign_in(:user, user)
      render json: user
    else
      invalid_login_attempt
    end
  end

  def destroy
    if user_signed_in?
      sign_out(current_user)
    end
    render status: :ok, nothing: true
  end

  def show
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
