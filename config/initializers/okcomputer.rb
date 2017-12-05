# frozen_string_literal: true
OkComputer.require_authentication(ENV['OKCOMPUTER_LOGIN'], ENV['OKCOMPUTER_PASSWORD'])
OkComputer.logger = Rails.logger

OkComputer::Registry.register 'datacite', OkComputer::DataciteConnectionCheck.new
