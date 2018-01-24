# frozen_string_literal: true
class EtdIndexer < Hyrax::WorkIndexer
  ##
  # Use the custom indexing service.
  #
  # This obviates inclusion of both `Hyrax::IndexesBasicMetadata` and
  # `Hyrax::IndexesLinkedMetadata`, which both override this method (and
  # conflict with one another in the process).
  def rdf_service
    IndexingService
  end

  ##
  # A custom indexing service based on Hyrax::DeepIndexingService
  #
  # This adds the specialized Etd fields
  class IndexingService < Hyrax::DeepIndexingService
    self.stored_fields += []
    self.stored_and_facetable_fields +=
      [:date, :date_label, :date_created, :degree, :department, :institution,
       :license, :orcid_id, :school, :rights_statement]

    stored_fields.delete(:license)
    stored_fields.delete(:rights_statement)

    ##
    # Index EDTF dates
    def generate_solr_document
      super.tap do |solr_doc|
        if object.date.any?
          date_key = Solrizer.solr_name('date')

          solr_doc[date_key] ||= []
          solr_doc[date_key] +=
            object.date.select { |date| date.respond_to?(:edtf) }.map(&:edtf)
        end
      end
    end
  end
end
