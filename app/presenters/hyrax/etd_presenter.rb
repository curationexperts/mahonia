# frozen_string_literal: true
module Hyrax
  class EtdPresenter < Hyrax::WorkShowPresenter
    delegate :date, :date_label, :degree, :department, :institution, :orcid_id,
             :orcid_id, :school, to: :solr_document

    ##
    # @return [String] A citation for the object
    def citation
      Mahonia::CitationFormatter.citation_for(object: solr_document)
    end
  end
end
