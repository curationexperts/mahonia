# frozen_string_literal: true
module Datacite
  ##
  # Builds XML records ready for use as a DataCite MDS body.
  #
  # @example building an XML record for use as an MDS request body
  #   builder = XmlBuilder.new
  #   builder.identifier = '10.55555/moomin'
  #
  #   builder.build
  #   # => "<?xml version=\"1.0\"?>\n<resource ...>...</resource>\n"
  #
  # @see https://support.datacite.org/v1.1/docs/mds-2p
  class XmlBuilder
    ATTRIBUTES = [:creators, :identifier, :publication_year,
                  :titles].freeze

    ##
    # Unknown/Unvailable/Null value constants
    # @see https://support.datacite.org/v1.1/docs/datacite-metadata-schema-40#section-appendix-3-additional-information
    INACCESSIBLE = ':unac' # temporarily inaccessible
    UNALLOWED    = ':unal' # unallowed, suppressed intentionally
    UNAPPLICABLE = ':unap' # not applicable, makes no sense
    UNASSIGNED   = ':unas' # value unassigned (e.g., Untitled)
    UNAVAILABLE  = ':unav' # value unavailable, possibly unknown
    UNKNOWN      = ':unkn' # known to be unknown (e.g., Anonymous, Inconnue)
    NONE         = ':none' # never had a value, never will
    NULL         = ':null' # explicitly and meaningfully empty
    TBA          = ':tba'  # to be assigned or announced late
    ET_ALIA      = ':etal' # too numerous to list (et alia)

    SCHEMA_VERSION = '4.0'

    ##
    # There is only one identifier type supported by DataCite. However, the
    # type *must* be included, so we hard code to 'DOI'.
    TYPE = 'DOI'

    # @see http://dictionary.casrai.org/Output_Types
    RESOURCE_TYPE         = 'Dissertation'
    RESOURCE_TYPE_GENERAL = 'Text'

    ##
    # @!attribute [rw] identifier
    #   @return [String]
    # @!attribute [rw] titles
    #   @return [Array<String>]
    attr_accessor(*ATTRIBUTES)

    ##
    # Builds XML for use as a DataCite MDS body.
    #
    # @return [String] an XML string
    # @see https://support.datacite.org/v1.1/docs/mds-2
    #
    # rubocop:disable Metrics/MethodLength
    def build
      Nokogiri::XML::Builder.new do |xml|
        xml.resource(xmlns:                'http://datacite.org/schema/kernel-4',
                     'xmlns:xsi':          'http://www.w3.org/2001/XMLSchema-instance',
                     'xsi:schemaLocation': 'http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd') do
          xml.identifier identifier, identifierType: TYPE

          xml.titles do
            maybe(:titles).each { |title| xml.title title }
          end

          xml.creators do
            maybe(:creators).each do |creator|
              xml.creator do
                xml.creatorName creator
              end
            end
          end

          xml.publicationYear publication_year if publication_year

          xml.resourceType RESOURCE_TYPE, resourceTypeGeneral: RESOURCE_TYPE_GENERAL

          xml.version SCHEMA_VERSION
        end
      end.to_xml
    end
    # @rubocop:enable Metrics/MethodLength

    ##
    # Empties all settings for the builder.
    #
    # @return [void]
    def clear
      self.identifier = nil
    end

    private

      ##
      # Always return a usable value for a given attribute.
      def maybe(name, status: [UNAVAILABLE])
        public_send(name) || status
      end
  end
end
