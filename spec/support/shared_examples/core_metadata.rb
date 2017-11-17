RSpec.shared_examples 'a model with ohsu core metadata' do
  subject(:model) { described_class.new }

  it { is_expected.to have_editable_property(:date,        RDF::Vocab::DC11.date) }
  it { is_expected.to have_editable_property(:date_label,  RDF::Vocab::DWC.verbatimEventDate) }
  it { is_expected.to have_editable_property(:description, RDF::Vocab::DC11.description) }
  it { is_expected.to have_editable_property(:keyword,     RDF::Vocab::SCHEMA.keywords) }
  it { is_expected.to have_editable_property(:rights_note, RDF::Vocab::DC11.rights) }
end
