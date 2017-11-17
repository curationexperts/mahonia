module Hyrax
  class EtdPresenter < Hyrax::WorkShowPresenter
    delegate :date_created, :date_label, :degree, :department, :institution,
             :orcid_id, :school, to: :solr_document
  end
end
