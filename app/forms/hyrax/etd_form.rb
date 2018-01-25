# frozen_string_literal: true
module Hyrax
  class EtdForm < Hyrax::Forms::WorkForm
    include SingleValuedForm
    include Mahonia::MeshTermService
    self.single_valued_fields = [:degree, :school, :department, :institution].freeze
    self.model_class = ::Etd
    self.terms -= [:publisher]
    self.terms += [:degree, :date, :date_label, :department, :institution, :orcid_id, :resource_type, :rights_note, :school]

    ##
    # Cast `:date` parameters from the form to EDTF.
    #
    # We don't care if the dates are valid. `"moomin"` is a perfectly acceptable
    # EDTF date for our purposes.
    def self.model_attributes(form_params)
      result = super
      result[:date].map! { |date| Mahonia::EdtfLiteral.new(date) }
      result[:publisher] = ["OHSU Scholar Archive"]
      result
    end
  end
end
