module Hyrax
  class EtdPresenter < Hyrax::WorkShowPresenter
    delegate :date, :date_label, :degree, :department, :institution, :orcid_id,
             :orcid_id, :school, to: :solr_document
  end
end
