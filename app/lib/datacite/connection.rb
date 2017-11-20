module Datacite
  class Connection
    ##
    # @!attribute [rw] configuration
    #   @return [Datacite::Configuration]
    # @!attribute [r] connection
    attr_accessor :configuration
    attr_reader   :connection

    ##
    # @param configuration [Datacite::Configuration]
    def initialize(configuration: Datacite::Configuration.instance)
      @configuration = configuration
      @connection    = Faraday.new(url: 'https://mds.test.datacite.org/')
      @connection.basic_auth configuration.login, configuration.password
    end

    ##
    # @param metadata [#identifier]
    # @return [#identifier] the registered metadata record
    def create(metadata:)
      # headers = {:"Content-Type" => "application/xml" }
      # connection.post('/metadata', 'moomin', headers)
      metadata
    end
  end
end
