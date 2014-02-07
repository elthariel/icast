server "icast.io", :app, :web, :db, :primary => true

set :user, 'production'
set :deploy_to, '/home/production/app'
set :branch, 'production'
set :rails_env, 'production'
