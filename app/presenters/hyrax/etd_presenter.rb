module Hyrax
  class EtdPresenter < Hyrax::WorkShowPresenter
    delegate :date_label, :degree, to: :solr_document
  end
end
