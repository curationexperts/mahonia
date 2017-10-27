module Schemas
  class CoreMetadata < ActiveTriples::Schema
    property :rights_note, predicate: RDF::Vocab::DC11.rights
  end
end
