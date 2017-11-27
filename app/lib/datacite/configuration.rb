# frozen_string_literal: true
module Datacite
  class Configuration
    include Singleton

    ##
    # @!attribute [rw] domains
    #   @return [String]
    # @!attribute [rw] host
    #   @return [String]
    # @!attribute [rw] login
    #   @return [String]
    # @!attribute [rw] password
    #   @return [String]
    # @!attribute [rw] prefix
    #   @return [String]
    attr_accessor :domains, :host, :login, :password, :prefix

    def initialize
      load_from_hash(Rails.application.config_for(:datacite)) if defined? Rails
    end

    ##
    # @param hash [Hash]
    # @return [Datacite::Configuration] self
    def load_from_hash(hash)
      self.domains  = hash.fetch('domains')
      self.host     = hash.fetch('host')
      self.login    = hash.fetch('login')
      self.password = hash.fetch('password')
      self.prefix   = hash.fetch('prefix')
    end
  end
end
