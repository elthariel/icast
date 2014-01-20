class ContributionAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user
  end

  def readable_by?(user)
    user.moderator? or user.root? or resource.user == user
  end

  def updatable_by?(user)
    readable_by?(user)
  end

  def deletable_by?(user)
    readable_by?(user)
  end

  def applicable_by?(user)
    return true if user.root? or user.moderator?
    if resource.new_content?
      user.can_create?(resource.contributable_type.constantize)
    else
      user.can_update?(resource.contributable)
    end
  end
end
