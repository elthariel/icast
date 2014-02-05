class ConfirmationsController < Devise::ConfirmationsController
  def after_confirmation_path_for(resource_name, resource)
    'http://localhost:9000/#/signin'
  end
end
