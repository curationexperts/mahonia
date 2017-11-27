# frozen_string_literal: true
module Schemas
  class EtdMetadata < ActiveTriples::Schema
    property :degree,      predicate: RDF::URI.intern('http://vivoweb.org/ontology/core#AcademicDegree')
    property :department,  predicate: RDF::URI.intern('http://vivoweb.org/ontology/core#AcademicDepartment')
    property :institution, predicate: RDF::Vocab::MARCRelators.dgg
    property :orcid_id,    predicate: RDF::URI.intern('http://vivoweb.org/ontology/core#orcidId')
    property :school,      predicate: RDF::URI.intern('http://vivoweb.org/ontology/core#School')
  end
end
