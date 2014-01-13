class Api::User::RegistrationsController < Api::BaseController
  resource_description do
    short 'User Registration'
    formats ['json']

    description <<-EOS

    ### Intro

    An User Registration represents the creation or deleting of a user account
    on our service. The account needs to be activated before you can log in with
    it. See 'Confirmations'

    ### Create an account

    To create an account, issue a POST on /user/registrations, with your email,
    password and password_confirmation. An email will be sent to the registered email
    to activate your account

    ### Delete an account !!!DANGEROUS!!!

    Using DELETE /user/registrations/current, you can _definitively_ delete the
    account you are currently logged in with from our servers. Please pay
    attention since there's no undo possible with this method.

    EOS
  end
  respond_to :json


  api :POST, '/user/registrations(.format)', 'Creates a new user account | SignUp'
  param :user_registration, Hash, desc: "A hash containing the keys 'email', 'password' and 'password_confirmation'"
  description <<-EOS
  ### Example

      {
        'user_registration': {
          email: 'my-super-email@provider.fr',
          password: 'my-password',
          password_confirmation: 'my-password'
        }
      }

  ### Return values

  This call returns a 201 status on success or a 422 otherwise.

  EOS
  def create
    @user = User.new(user_registration_params)

    if @user.save
      render status: :created, json: {message: 'Confirmation email sent, please check you mailbox'}
    else
      render status: :unprocessable_entity, json: @user.errors
    end
  end



  api :DELETE, '/user/registrations/current(.format)', 'Permanently delete the currently logged in user'
  def destroy
    if user_signed_in?
      current_user.destroy
      render status: :ok, nothing: true
    else
      render status: :not_found, nothing: true
    end
  end

  protected
  def user_registration_params
    params.require(:user_registration).permit(:email, :password, :password_confirmation)
  end
end
