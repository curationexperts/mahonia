module Mahonia
  class DataciteRegistrar < IdentifierRegistrar
    IdentifierRecord = Struct.new(:identifier)

    ##
    # @param builder [Mahonia::IdentifierBuilder]
    def initialize(builder: Mahonia::DataciteDoiBuilder.new)
      super
    end

    ##
    # @see IdentifierRegistrar#register!
    def register!(*)
      IdentifierRecord.new(builder.build)
    end
  end
end
