# frozen_string_literal: true
set :stage, :dev
set :rails_env, 'production'
server '34.209.202.103', user: 'deploy', roles: [:web, :app, :db]
