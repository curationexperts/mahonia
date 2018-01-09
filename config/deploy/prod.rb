# frozen_string_literal: true
set :stage, :qa
set :rails_env, 'production'
server '54.148.202.35', user: 'deploy', roles: [:web, :app, :db]
