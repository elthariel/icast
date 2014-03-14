class ContributionSerializer < ApplicationSerializer
  attributes :id, :contributable_type, :contributable_id, :data, :applied_at
end
