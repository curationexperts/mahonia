set :stage, :sandbox
set :rails_env, 'production'
server '54.198.98.64', user: 'deploy', roles: [:web, :app, :db]
