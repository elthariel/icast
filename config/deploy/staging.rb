server "staging.icast.io", :app, :web, :db, :primary => true

set :user, 'staging'
set :deploy_to, '/home/staging/app'
set :branch, 'master'
set :rails_env, 'staging'
