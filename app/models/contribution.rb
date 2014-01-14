class Contribution < ActiveRecord::Base
  include Authority::Abilities
  self.authorizer_name = 'ContributionAuthorizer'

  belongs_to :user
  belongs_to :contributable, polymorphic: true

  validates :user,                presence: true
  validates :contributable_type,  presence: true # FIXME Validates contributable_type
  validate  :contribution_valid?

  scope :not_applied, -> { where(applied_at: nil)}
  scope :applied,     -> { where('applied_at IS NOT NULL')}

  def new_content?
    contributable_id.nil?
  end

  def applied?
    not applied_at.nil?
  end

  def apply!
    record = apply
    record.save!
    save! # To update 'applied_at' attribute
    record
  end

  def apply(for_validation=false)
    if new_content?
      record = contributable_type.constantize.new(data.to_h)
    else
      record = for_validation ? contributable.dup : contributable
      record.attributes = data
    end

    self.applied_at = DateTime.now unless for_validation

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
