class Api::User::RegistrationsController < Api::BaseController
  respond_to :json

  def create
    @user = User.new(user_registration_params)

    if @user.save
      render status: :created, json: {message: 'Confirmation email sent, please check you mailbox'}
    else
      render status: :unprocessable_entity, json: @user.errors
    end
  end

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
