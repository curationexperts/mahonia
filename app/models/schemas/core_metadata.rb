module Schemas
  class CoreMetadata < ActiveTriples::Schema
    property :date_label,  predicate: RDF::Vocab::DWC.verbatimEventDate
    property :keyword,     predicate: RDF::Vocab::SCHEMA.keywords
    property :rights_note, predicate: RDF::Vocab::DC11.rights
  end
end
