# frozen_string_literal: true
# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, "mahonia"
set :repo_url, "https://github.com/curationexperts/mahonia.git"

set :deploy_to, '/opt/mahonia'

set :log_level, :debug
set :bundle_flags, '--deployment'
set :bundle_env_variables, nokogiri_use_system_libraries: 1

set :keep_releases, 5
set :assets_prefix, "#{shared_path}/public/assets"

SSHKit.config.command_map[:rake] = 'bundle exec rake'

set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'

append :linked_dirs, "log"
append :linked_dirs, "public/assets"

append :linked_files, "config/database.yml"
append :linked_files, "config/secrets.yml"
