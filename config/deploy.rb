#
# Deploy configuration for RadiOxyde
#

require 'capistrano/ext/multistage'

# Ruby interpreter automatic deployment
set :rbenv_ruby_version, 'rbx-2.2.4'

set :application,   'icast'
set :scm,           :git
set :repository,    'git@github.com:elthariel/icast.git'
set :deploy_via,    :remote_cache
set :use_sudo,      false
set :sudo,          'env'

set :format,        :pretty
set :log_level,     :debug

set :shared_children, shared_children + %w{public/uploads public/assets tmp/pids}
set :keep_releases, 5

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

require 'capistrano-rbenv'
require 'bundler/capistrano'
require 'puma/capistrano'
