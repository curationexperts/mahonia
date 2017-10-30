module Hyrax
  class EtdPresenter < Hyrax::WorkShowPresenter
    delegate :date_label, to: :solr_document
  end
end
