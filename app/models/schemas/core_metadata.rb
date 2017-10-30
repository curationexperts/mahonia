module Schemas
  class CoreMetadata < ActiveTriples::Schema
    property :date_label,  predicate: RDF::Vocab::DWC.verbatimEventDate
    property :rights_note, predicate: RDF::Vocab::DC11.rights
  end
end
