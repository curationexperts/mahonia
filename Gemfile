# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '~> 2.4.2'

# DCE importer
gem 'darlingtonia', '0.3.0'
gem 'dotenv-rails'
gem 'honeybadger', '~> 3.1'
gem 'hydra-role-management', '~> 1.0'
gem 'pg', '~>0.21'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.6'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'sidekiq', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.3'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'bixby', '~> 0.3.1'
  gem "capistrano", "~> 3.10"
  gem 'capistrano-bundler', '~> 1.3'
  gem 'capistrano-ext'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq', '~> 0.20.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'hyrax', '~> 2.0.0'
group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
end

gem 'citeproc-ruby', '~> 1.0', '>= 1.0.6'
gem 'csl-styles'
gem 'devise', '~> 4.4', '>= 4.4.1'
gem 'devise-guests', '~> 0.6'
gem 'edtf', '~> 3.0'
gem 'okcomputer', '~> 1.17', '>= 1.17.1'
gem 'rsolr', '>= 1.0'

group :development, :test do
  gem 'database_cleaner'
  gem 'fcrepo_wrapper'
  gem 'ffaker'
  gem 'hyrax-spec', '~> 0.3.0'
  gem 'rspec-rails'
  gem 'webmock', '~> 3.1', '>= 3.1.1'
end

group :test do
  gem 'capybara',          '~> 2.15.4'
  gem 'chromedriver-helper'
  gem 'coveralls',          require: false
  gem 'factory_bot_rails',  '~> 4.8.0'
  gem 'selenium-webdriver'
end
