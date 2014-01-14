server "radioxide.lta.io", :app, :web, :db, :primary => true

# Thin prod conf
set :thin_port,                 7420
set :thin_max_conns,            1024
set :thin_max_persistent_conns, 1024
set :thin_servers,              4

set :user, 'radioxide'
set :deploy_to, '/home/radioxide/webapp'
set :branch, 'master'
set :rails_env, 'staging'
