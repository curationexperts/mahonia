module Hyrax
  class EtdForm < Hyrax::Forms::WorkForm
    SINGLE_VALUE = [:degree].freeze

    self.model_class = ::Etd
    self.terms += [:degree, :date_label, :institution, :orcid_id,
                   :resource_type, :rights_note]

    ##
    # @return [Boolean]
    # @see Hyrax::Forms::WorkForm#multiple?
    def multiple?(field)
      return false if SINGLE_VALUE.include?(field)
      super
    end
  end
end
