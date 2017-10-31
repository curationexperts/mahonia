module Hyrax
  class EtdPresenter < Hyrax::WorkShowPresenter
    delegate :date_label, :degree, :institution, :orcid_id, to: :solr_document
  end
end
