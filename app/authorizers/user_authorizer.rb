# This authorizer is only supposed to be user by ActiveAdmin via the
# AuthorityAdapter class. Regular devise rules should apply otherwise
class UserAuthorizer < ApplicationAuthorizer
  def updatable_by?(user)
    user == resource
  end

  class << self
    def readable_by?(user)
      user.root? or user.moderator?
    end

    def creatable_by?(user)
      user.root?
    end

    def updatable_by?(user)
      creatable_by? user
    end

    def deletable_by(user)
      creatable_by? user
    end
  end
end
