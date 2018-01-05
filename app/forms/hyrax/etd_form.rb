# frozen_string_literal: true
module Hyrax
  class EtdForm < Hyrax::Forms::WorkForm
    include SingleValuedForm
    self.single_valued_fields = [:degree, :school, :department, :institution].freeze
    self.model_class = ::Etd

    model_class::EXCLUDED_TERMS.each { |term| terms.delete(term) }
    self.terms += [:degree, :date, :date_label, :department, :institution, :orcid_id, :resource_type, :rights_note, :school]
  end
end
