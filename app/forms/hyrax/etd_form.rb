module Hyrax
  class EtdForm < Hyrax::Forms::WorkForm
    self.model_class = ::Etd
    self.terms += [:date_label, :resource_type, :rights_note]
  end
end
