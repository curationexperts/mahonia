# frozen_string_literal: true

module Mahonia
  class EdtfLiteral < RDF::Literal
    DATATYPE = RDF::URI('http://id.loc.gov/datatypes/edtf/EDTF')

    # support ActiveJob serialization
    include GlobalID::Identification

    def self.find(id)
      new(id)
    end

    def initialize(value, **opts)
      value = EDTF.parse(value) || value
      @string = value.edtf if value.respond_to? :edtf
      super
    end

    def id
      value
    end
  end
end
