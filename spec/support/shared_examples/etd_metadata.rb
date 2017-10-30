RSpec.shared_examples 'a model with ohsu ETD metadata' do
  subject(:model)  { described_class.new }
  let(:degree_uri) { RDF::URI.intern('http://vivoweb.org/ontology/core#AcademicDegree') }

  it { is_expected.to have_editable_property(:degree, degree_uri) }
end
