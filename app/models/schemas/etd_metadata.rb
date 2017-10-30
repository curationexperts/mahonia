module Schemas
  class EtdMetadata < ActiveTriples::Schema
    property :degree, predicate: RDF::URI.intern('http://vivoweb.org/ontology/core#AcademicDegree')
  end
end
