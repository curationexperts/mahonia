# frozen_string_literal: true
set :stage, :stage
set :rails_env, 'production'
server '52.42.114.250', user: 'deploy', roles: [:web, :app, :db]
