module Mahonia
  class DataciteRegistrar < IdentifierRegistrar
    IdentifierRecord = Struct.new(:identifier)

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
    # @see IdentifierRegistrar#register!
    def register!(object:)
      record = IdentifierRecord.new(builder.build(hint: object.id))
      connection.create(metadata: record)
    end

    private

      def prefix
        Datacite::Configuration.instance.prefix
      end
  end
end
