class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  as_enum :role, default: 0, moderator: 1, root: 2

  # Adds `can_create?(resource)`, etc
  include Authority::UserAbilities

  has_many :contributions
end
