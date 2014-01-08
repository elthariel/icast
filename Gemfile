source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use PostgreSQL as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
gem 'debugger', group: [:development, :test]

################
# Classic gems #

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker', github: 'stympy/faker'
  gem 'rspec-rails'
  gem 'simplecov', :require => false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'quiet_assets'

  # Better rails console
  gem 'pry'

  # Transform html/erb templates to slim templates
  gem 'html2slim'
end

# Templating language, to avoid touching dirty html with their ugly <>
gem 'slim-rails'

# Authentication
gem 'devise'

# Admin interface
gem 'activeadmin', github: 'gregbell/active_admin'

# Model Serialization
gem 'active_model_serializers'

# Handle tagging of Model
gem 'acts-as-taggable-on'

# Handle configuration management
gem 'figaro'

# Redis goodness to handle fast changing data
gem 'redis'
gem 'redis-objects'

# Image upload
gem 'carrierwave'
gem 'mini_magick'

# UNUSED Active Record enumerations
# gem 'simple_enum'

# Slug generation
gem 'friendly_id', '~> 5.0.0'
