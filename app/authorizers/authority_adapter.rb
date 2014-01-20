class AuthorityAdapter < ActiveAdmin::AuthorizationAdapter
  ACTION_MAPPING = {
    destroy:  :delete
  }.freeze

  def authorized?(action, subject)
    puts "AuthorityAdapter:: #{action} on #{subject}"

    case subject
    when normalized(ActiveAdmin::Page)
      true
    when normalized(ActiveAdmin::Comment)
      true
    else
      action = ACTION_MAPPING.has_key?(action) ? ACTION_MAPPING[action] : action

      user.send("can_#{action}?", subject)
    end
  end
end
