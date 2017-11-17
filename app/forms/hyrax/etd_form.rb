module Hyrax
  class EtdForm < Hyrax::Forms::WorkForm
    SINGLE_VALUE = [:degree, :school, :department].freeze

    self.model_class = ::Etd
    self.terms += [:degree, :date, :date_label, :department, :institution,
                   :orcid_id, :resource_type, :rights_note, :school]

    ##
    # @return [Boolean]
    # @see Hyrax::Forms::WorkForm#multiple?
    def multiple?(field)
      return false if SINGLE_VALUE.include?(field)
      super
    end
  end
end
