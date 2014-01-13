class Contribution < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'ContributionAuthorizer'

  belongs_to :user
  belongs_to :contributable, polymorphic: true

  validates :user,                presence: true
  validates :contributable_type,  presence: true # FIXME Validates contributable_type
  validate  :contribution_valid?


  def new_content?
    contributable_id.nil?
  end

  def apply!
    record = apply
    record.save!
    save! # To update 'applied_at' attribute
    record
  end

  def apply(dupme=false)
    if new_content?
      record = contributable_type.constantize.new(data)
    else
      record = dupme ? contributable.dup : contributable
      record.attributes = data
    end

    self.applied_at = DateTime.now

    record
  end

  def contribution_valid?
    record = apply(true)

    unless record.valid?
      record.errors.each do |attribute, message|
        errors.add attribute, message
      end
    end
  end

end
