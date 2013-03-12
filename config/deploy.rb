# Config this
set :repository,      "git://github.com/CodeCantor/gitlabhq.git"
set :application, 'gitlabhq'

#########
set :stages, %w(production staging)
set :default_stage, "production"
require 'capistrano/ext/multistage'
require 'capistrano/chef'

default_environment["RAILS_ENV"] = "#{rails_env}"
require "capistrano/configuration/actions/file_transfer"
require "bundler/capistrano"

set :bundle_without,      [:development, :test, :mysql]

set :scm,             :git
set :sudo_user,	      'deploy'

set :migrate_target,  :current
set :deploy_to,       "/var/www/#{application}"

require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3-p327@bundle'        # Or whatever env you want
set :rvm_type, :system  # Copy the exact line. I really mean :user here

namespace :gitlab do
  desc "Create symlink for gitlab config"
  task :symlink do
    run "ln -nfs #{shared_path}/config/gitlab.yml #{current_path}/config/gitlab.yml"
  end
  after "deploy:finalize_update", "gitlab:symlink"

  desc "Upload twitter_config"
  task :setup do
    upload "config/gitlab.yml", "#{shared_path}/config/gitlab.yml", via: :scp
  end  
  after "deploy:setup", "gitlab:setup"
end

namespace :newrelic do
  desc "Create symlink for newrelic config"
  task :symlink do
    run "ln -nfs #{shared_path}/config/newrelic.yml #{current_path}/config/initializers/newrelic.yml"
  end
  after "deploy:finalize_update", "newrelic:symlink"

  desc "Upload twitter_config"
  task :setup do
    upload "config/initializers/newrelic.yml", "#{shared_path}/config/newrelic.yml", via: :scp
  end  
  after "deploy:setup", "newrelic:setup"
end
def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end
