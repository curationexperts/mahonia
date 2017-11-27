# coding: utf-8
# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mahonia
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.to_prepare do
      Hyrax::CurationConcern.actor_factory.use Hyrax::Actors::DataciteActor
    end
  end
end

Rails.application.routes.default_url_options[:host] =
  ENV['RAILS_HOST'] || 'localhost'
