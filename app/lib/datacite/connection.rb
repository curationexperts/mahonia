# frozen_string_literal: true
module Datacite
  ##
  # A light wrapper around the DataCite Metadata Store (MDS) API v2.
  #
  # The API supports creating new metadata records for DOIs and registering the
  # DOI/metadata to a given URL. This is a two step process implemented here as
  # `#create` and `#register`.
  #
  # The creation step creates a metadata record in the DataCite MDS. The
  # registration step adds a handle record. The TTL on DataCite handles is 24
  # hours, so records may not appear or update immediately upstream when
  # `#register` is called.
  #
  # @example Creating and registering a DOI
  #   connection = Datacite::Connection.new
  #
  #   # We need a record with an identifier, anything responding to
  #   # `#identifier` with a DOI string will work.
  #   Record = Struct.new(:identifier)
  #   record = Record.new('10.5072/moomin')
  #
  #   connection.create(metadata: record)
  #   connection.register(metadata: record, url: 'http://example.com/moomin')
  #
  # @example Creating a DOI with rich metadata
  #   connection = Datacite::Connection.new
  #
  #   Record = Struct.new(:identifier, :title, :creator, :publicationYear)
  #   record = Record.new('10.5072/moomin', ['Kometjakten'], ['Tove Jansson'], '1946')
  #
  #   connection.create(metadata: record)
  #
  # @see https://support.datacite.org/docs/mds-2
  class Connection
    METADATA_PATH  = '/metadata'
    REGISTER_PATH  = '/doi'
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
    # @note required fields are: creators, publicationYear,
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
        connection.get Pathname.new(METADATA_PATH).join(metadata.identifier).to_s

      raise Error.new('', response) unless response.status == STATUS_OK

      doc        = Nokogiri::XML(response.body)
      identifier = doc.xpath('//xmlns:identifier', doc.namespaces).text

      ResponseRecord.new(identifier)
    end

    ##
    # Register the URL for a DOI.
    #
    # @param metadata [#identifier]
    # @param url      [String]
    #
    # @return [#identifier] the metadata record returned from the server
    # @raise [Datacite::Connection::Error]
    def register(metadata:, url:)
      headers  = { 'Content-Type': 'text/plain;charset=UTF-8' }
      path     = Pathname.new(REGISTER_PATH).join(metadata.identifier).to_s
      payload  = "doi=#{metadata.identifier}\nurl=#{url}"

      response = connection.put(path, payload, headers)
      raise Error.new('', response) unless response.status == STATUS_CREATED

      metadata
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
        response = connection.post(METADATA_PATH, body, headers)

        raise Error.new('', response) unless response.status == STATUS_CREATED
      end
  end
end
