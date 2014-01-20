ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :confirmed_at, :role_cd

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end

      params[:user].delete(:role_cd) unless current_user.root?

      super
    end
  end

  filter :email
  filter :role_cd

  index do
    column :email
    column :role
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation

      f.input :role_cd, as: :select, collection: User.roles, include_blank: false

      f.input :confirmed_at
    end
    f.actions
  end

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

end
