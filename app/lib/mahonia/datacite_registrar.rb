module Mahonia
  class DataciteRegistrar < IdentifierRegistrar
    IdentifierRecord = Struct.new(:identifier)

    def register!(*)
      IdentifierRecord.new('moomin')
    end
  end
end
