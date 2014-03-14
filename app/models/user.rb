class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  as_enum :role, default: 0, moderator: 1, root: 2

  # Adds `can_create?(resource)`, etc
  include Authority::UserAbilities

  # Adds 'creatable_by?(user)', etc. # i.e. who can edit/create users.
  # This is only used in ActiveAdmin. Regular devise rules applies otherwise
  include Authority::Abilities
  self.authorizer_name = 'UserAuthorizer'

  has_many :contributions

  acts_as_voter

  def display_name
    email
  end

  def cache_key
    ["uid:#{self.id}", "t#{self.updated_at.to_time.to_i}"]
  end
end
