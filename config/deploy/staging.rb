server "icast.lta.io", :app, :web, :db, :primary => true

# Thin prod conf
set :thin_port,                 7420
set :thin_max_conns,            1024
set :thin_max_persistent_conns, 1024
set :thin_servers,              4

set :user, 'icast'
set :deploy_to, '/home/icast/webapp'
set :branch, 'master'
set :rails_env, 'staging'
