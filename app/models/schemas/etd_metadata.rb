module Schemas
  class EtdMetadata < ActiveTriples::Schema
    property :degree,      predicate: RDF::URI.intern('http://vivoweb.org/ontology/core#AcademicDegree')
    property :institution, predicate: RDF::Vocab::MARCRelators.dgg
  end
end
