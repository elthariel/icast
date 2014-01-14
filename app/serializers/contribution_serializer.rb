class ContributionSerializer < ActiveModel::Serializer
  attributes :id, :contributable_type, :contributable_id, :data, :applied_at
end
