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
    def self.stored_and_facetable_fields
      @stored_and_facetable_fields ||=
        (Hyrax::DeepIndexingService.stored_and_facetable_fields.dup << :date_label)
    end
  end
end
