# frozen_string_literal: true
module Mahonia
  class DataciteRegistrar < IdentifierRegistrar
    IdentifierRecord =
      Struct.new(:identifier, :creator, :publisher, :publication_year, :title)

    ##
    # @!attribute [rw] connection
    #   @return [Datacite::Connection]
    attr_accessor :connection

    ##
    # @param builder    [Mahonia::IdentifierBuilder]
    # @param connection [Datacite::Connection]
    def initialize(builder:    Mahonia::IdentifierBuilder.new(prefix: prefix),
                   connection: Datacite::Connection.new)
      @connection = connection
      super(builder: builder)
    end

    ##
    # @return [Mahonia::DataciteRegistrar::IdentifierRecord]
    def record_for(object:)
      IdentifierRecord.new(builder.build(hint: object.id),
                           object.try(:creator),
                           object.try(:publisher),
                           object.try(:date_uploaded).try(:year),
                           object.try(:title))
    end

    ##
    # @see IdentifierRegistrar#register!
    def register!(object:)
      metadata = record_for(object: object)

      result = connection.create(metadata: metadata)
      connection.register(metadata: result,
                          url:      Etd.application_url(id: object.id))
      result
    end

    private

      def prefix
        Datacite::Configuration.instance.prefix
      end
  end
end
