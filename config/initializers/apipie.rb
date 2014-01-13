Apipie.configure do |config|
  config.app_name                = "RadiOxide"
  config.api_base_url            = "/api/1"
  config.doc_base_url            = "/api/doc"
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"

  # Don't use apipie parameter validation
  config.validate = false

  # Use Markdown for template language in Apipie
  config.markup = Apipie::Markup::Markdown.new
end
