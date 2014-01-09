class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #####################
  # Active Admin setup
  helper_method :current_admin_user, :authenticate_admin_user!

  def authenticate_admin_user!
    authenticate_user!
  end
  def current_admin_user
    if current_user and current_user.role_cd > 0
      current_user
    else
      nil
    end
  end
end
