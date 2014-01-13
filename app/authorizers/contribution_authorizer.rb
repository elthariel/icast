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
end
