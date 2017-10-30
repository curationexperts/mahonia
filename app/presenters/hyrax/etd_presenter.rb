module Hyrax
  class EtdPresenter < Hyrax::WorkShowPresenter
    delegate :date_label, :degree, :institution, :orcid_id, :school, to: :solr_document
  end
end
