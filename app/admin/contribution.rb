ActiveAdmin.register Contribution do
  permit_params :user_id, :contributable_type, :contributable_id, :data

  scope :all
  scope :not_applied, default: true
  scope :applied

  member_action :apply, :method => :post do
    contrib = Contribution.find(params[:id])
    authorize! :apply, contrib
    contrib.apply!
    redirect_to admin_contributions_path, :notice => "Applied!"
  end

  index do
    column :id
    column :user
    column :contributable
    column :applied_at
    column :created_at
    column :data
    actions do |contrib|
      if not contrib.applied? and authorized?(:apply, contrib)
        link_to 'Apply!', apply_admin_contribution_path(contrib), method: :post, data: {confirm: 'Are you sure ?'}
      end
    end
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
