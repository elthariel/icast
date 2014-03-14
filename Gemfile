source 'https://rubygems.org'

gem 'racc', platform: :ruby

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use PostgreSQL as the database for Active Record
gem 'pg', platforms: :ruby
gem 'activerecord-jdbcpostgresql-adapter', platform: :jruby

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
# gem 'jquery-rails'

# Templating languages
gem 'haml-rails'
gem 'slim-rails'

# Twitter bootstrap goodness
gem 'bootstrap-sass'
## FontAwesome for bootstrap
gem 'font-awesome-sass'

# Integrate Bower with rails
gem 'bower-rails'

# Handle gracefully AngularJS minification with dependency injection
gem 'ngmin-rails'

################
# Classic gems #
group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker', github: 'stympy/faker'
  gem 'rspec-rails'
  gem 'simplecov', :require => false
  gem 'coveralls', require: false

  # Better rails console
  gem 'pry'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'quiet_assets'

  # Transform html/erb templates to slim templates
  gem 'html2slim'

  # Use Capistrano for deployment
  gem 'capistrano', '~> 2'
  gem 'capistrano-ext'
  gem 'capistrano-rbenv'#, '~> 1.0' # Setup rbenv and use it
end

# Let's try the new kid on the block
gem 'puma'

#######################################################
## Back-End / Api  ###
######################

# Optimised Json
gem 'oj', platforms: :ruby

# Authentication
gem 'devise'

# ACL definition
gem 'authority'

# Admin interface
gem 'activeadmin', github: 'gregbell/active_admin'
# FIXME Implement me later gem 'country-select'

# Model Serialization
gem 'active_model_serializers', '~> 0.8.1'

# Handle tagging of Model
gem 'acts-as-taggable-on'

# Handle configuration management
gem 'figaro'

# Redis goodness to handle fast changing data
gem 'redis-rails'
gem 'redis-objects'

# Image upload
gem 'carrierwave'
gem 'mini_magick'

# Active Record enumerations
gem 'simple_enum'

# Slug generation
gem 'friendly_id', '~> 5.0.0'

# The cool XML (can xml be cool? i doubt it) parser
gem 'nokogiri', require: false

# List of countries and country specific data
gem 'countries'

# API Documentation generation
gem 'apipie-rails'
gem 'maruku' # doc markdown parsing

# Geolocation gems
gem 'geoip'
gem 'geocoder'

# Full text search and shit
gem 'tire'

# Happy Hashes
gem 'hashie'

# Handle CORS policy for the API
gem 'rack-cors', :require => 'rack/cors'

# Handle popularity and stuff
gem 'acts_as_votable', '~> 0.8.0'
