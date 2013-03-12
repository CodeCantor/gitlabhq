set :rails_env,       "production"
set :branch,          "origin/stable"
default_environment["RAILS_ENV"] = "#{rails_env}"
set :server_name, 'git.codecantor.com'

chef_role :web, 'roles:app_gitlab'
chef_role :app, 'roles:app_gitlab'
chef_role :db, 'roles:app_gitlab', primary: true
