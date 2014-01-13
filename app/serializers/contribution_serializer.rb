class ContributionSerializer < ActiveModel::Serializer
  attributes :id, :contribution_type, :contribution_id, :data
  has_one :user
end
