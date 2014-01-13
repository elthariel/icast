class Api::User::PasswordsController < Api::BaseController
  resource_description do
    short 'User Password'
    formats ['json']

    description <<-EOS

    ### Intro

    This resource represents an User password. You can use it to change the
    current's user password.

    EOS
  end

  before_action :authenticate_user!
  respond_to :json

  api :POST, '/user/passwords', 'Change the current user\'s password'
  param :user_password, Hash, "A hash containing the keys 'old_password', 'password' and 'password_confirmation'"
  description <<-EOS
    ### Changing the user password.

    This API call allows you to change the currently logged in user's password.
    You need to provide the current password in the field 'old_password', and
    the future-new password in the fields 'password' and
    'password_confirmation'.

    ### Example
        {
          "user_password": {
            "old_password": "my_old_password",
            "password": "the_new_password_i_want_to_define",
            "password_confirmation": "the_new_password_i_want_to_define"
          }
        }

    ### Return value

    This call returns with a status of '200' if password was changed, and with a
    status of '422' otherwise.

  EOS
  def create
    old_password = params[:user_password].delete(:old_password)

    if current_user and current_user.valid_password?(old_password)
      if current_user.update_attributes(user_password_params)
        render status: :ok, nothing: true
      else
        render status: :unprocessable_entity, json: current_user.errors
      end
    else
      render status: :unprocessable_entity, nothing: true
    end
  end

  protected
  def user_password_params
    params.require(:user_password).permit(:old_password, :password, :password_confirmation)
  end
end
