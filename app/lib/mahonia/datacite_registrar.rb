module Mahonia
  class DataciteRegistrar < IdentifierRegistrar
    IdentifierRecord = Struct.new(:identifier)

    ##
    # @!attribute [rw] connection
    #   @return [Datacite::Connection]
    attr_accessor :connection

    ##
    # @param builder [Mahonia::IdentifierBuilder]
    def initialize(builder:    Mahonia::DataciteDoiBuilder.new,
                   connection: Datacite::Connection.new)
      @connection = connection
      super(builder: builder)
    end

    ##
    # @see IdentifierRegistrar#register!
    def register!(*)
      record = IdentifierRecord.new(builder.build)
      connection.create(metadata: record)
    end
  end
end
