module Hyrax
  class EtdPresenter < Hyrax::WorkShowPresenter
    delegate :date_label, :degree, :institution, to: :solr_document
  end
end
