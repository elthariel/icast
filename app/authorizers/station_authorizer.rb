class StationAuthorizer < ApplicationAuthorizer
  def self.readable_by?(user)
    true
  end

  def self.creatable_by?(user)
    user
  end

  def updatable_by?(user)
    user.moderator? or user.root? or resource.user == user
  end

  def deletable_by?(user)
    updatable_by?(user)
  end
end
