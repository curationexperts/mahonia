RSpec.shared_examples 'a model with ohsu ETD metadata' do
  subject(:model)       { described_class.new }
  let(:degree_uri)      { RDF::URI.intern('http://vivoweb.org/ontology/core#AcademicDegree') }
  let(:institution_uri) { RDF::Vocab::MARCRelators.dgg }
  let(:orcid_uri)       { RDF::URI.intern('http://vivoweb.org/ontology/core#orcidId') }
  let(:school_uri) { RDF::URI.intern('http://vivoweb.org/ontology/core#School') }

  it { is_expected.to have_editable_property(:degree, degree_uri) }
  it { is_expected.to have_editable_property(:institution, institution_uri) }
  it { is_expected.to have_editable_property(:orcid_id).with_predicate(orcid_uri) }
  it { is_expected.to have_editable_property(:school, school_uri) }
end
