# frozen_string_literal: true
module Datacite
  class Connection
    POST_PATH      = '/metadata'
    STATUS_CREATED = 201
    STATUS_OK      = 200

    ResponseRecord = Struct.new(:identifier)

    ##
    # @!attribute [rw] configuration
    #   @return [Datacite::Configuration]
    # @!attribute [r] connection
    #   @return [Faraday::Connection]
    # @!attribute [rw] content_builder
    #   @return [#build]
    attr_accessor :configuration, :content_builder
    attr_reader   :connection

    ##
    # @param configuration   [Datacite::Configuration]
    # @param content_builder [#build]
    def initialize(configuration:   Datacite::Configuration.instance,
                   content_builder: Datacite::XmlBuilder.new)
      @configuration   = configuration
      @connection      = Faraday.new(url: configuration.host)
      @content_builder = content_builder
      @connection.basic_auth configuration.login, configuration.password
    end

    ##
    # @param metadata [#identifier]
    #
    # @return [#identifier] the registered metadata record
    # @raise [Datacite::Connection::Error]
    #
    # @note required fields are: creators, publisher, publicationYear,
    #   resourceType, subjects, contributors, dates, language,
    #   alternateIdentifiers, relatedIdentifiers, sizes, formats, version,
    #   rightsList, descriptions, geoLocations; according to HTTP responses.
    def create(metadata:)
      populate_builder(metadata: metadata)
      post(body: content_builder.build)
      metadata
    end

    ##
    # @note this method currently returns a pared down record containing only
    #   the identifier. It may be extended in the future to map back from XML.
    #
    # @param metadata [#identifier]
    #
    # @return [#identifier] the metadata record returned from the server
    # @raise [Datacite::Connection::Error]
    def get(metadata:)
      response =
        connection.get Pathname.new(POST_PATH).join(metadata.identifier).to_s

      raise Error.new('', response) unless response.status == STATUS_OK

      doc        = Nokogiri::XML(response.body)
      identifier = doc.xpath('//xmlns:identifier', doc.namespaces).text

      ResponseRecord.new(identifier)
    end

    class Error < RuntimeError
      ##
      # @!attribute [r] status
      #   @return [Integer]
      attr_reader :status

      ##
      # @param msg      [String]
      # @param response [Faraday::Response]
      def initialize(msg = '', response = nil)
        if response
          @status = response.status
          msg += "#{@status}: #{response.reason_phrase}\n\n"
          msg += response.body
        end

        super(msg)
      end
    end

    private

      ##
      # @return [void]
      def populate_builder(metadata:)
        content_builder.identifier       = metadata.identifier
        content_builder.titles           = metadata.try(:title)
        content_builder.creators         = metadata.try(:creator)
        content_builder.publication_year = metadata.try(:publicationYear) || Time.zone.today.year
      end

      ##
      # @return [void]
      def post(body:)
        headers  = { "Content-Type": "application/xml" }
        response = connection.post(POST_PATH, body, headers)

        raise Error.new('', response) unless response.status == STATUS_CREATED
      end
  end
end
