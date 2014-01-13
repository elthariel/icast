class Api::User::ConfirmationsController < Api::BaseController
  resource_description do
    short 'User Registration'
    formats ['json']

    description <<-EOS

    ### Intro

    An User Confirmation represents the validation of the existence of an email address
    associated with a registered account.

    Direct account validation cannot be performed using this API. Recently registered users
    must click on the link they receive by email to activate their account. Meanwhile, you
    can ask the confirmation email to be sent again using this api

    ### Validates an account('s email address)

    EOS
  end
  respond_to :json

  api :POST, '/user/confirmations', 'Send the user confirmation email again'
  param :email, String, 'The email address associated to the account to send a confirmation email for'
  description <<-EOS
    This API call never fails and always returns a status '200', with an empty response
  EOS
  def create
    @user = User.where(email: params[:email]).first

    if @user
      @user.resend_confirmation_instructions
    end

    render status: :created, nothing: true
  end
end
