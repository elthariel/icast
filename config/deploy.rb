#
# Deploy configuration for RadiOxyde
#

require 'capistrano-thin'
require 'capistrano/ext/multistage'

set :application,   'icast'
set :scm,           :git
set :repository,    'git@github.com:elthariel/icast.git'
set :deploy_via,    :remote_cache
set :use_sudo,      false

set :format,        :pretty
set :log_level,     :debug

set :shared_children, shared_children + %w{public/uploads}
set :keep_releases, 5

# RVM automatic deployment
set :rvm_ruby_string, 'ruby-2.0.0-p353'
before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'   # install RVM

namespace :db do
  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/GeoLiteCity.dat #{release_path}/config/GeoLiteCity.dat"
  end
end
after  "deploy:update_code",        "db:symlink"
after  'deploy:update_code',        'deploy:migrate'

before "deploy:assets:precompile",  "db:symlink"


require 'rvm/capistrano'
require 'bundler/capistrano'
