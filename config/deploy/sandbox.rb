# frozen_string_literal: true
set :stage, :sandbox
set :rails_env, 'production'
server 'mahonia.curationexperts.com', user: 'deploy', roles: [:web, :app, :db]
