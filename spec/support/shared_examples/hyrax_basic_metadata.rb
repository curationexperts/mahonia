RSpec::Matchers.define :have_editable_property do |property, predicate|
  match do |model|
    values = ['Comet in Moominland', 'Moomin Midwinter']

    expect { model.public_send("#{property}=", values) }
      .to change { model.public_send(property).to_a }
      .to contain_exactly(*values)

    expect(model.resource.statements)
      .to include(RDF::Statement(model.rdf_subject,
                                 predicate,
                                 'Comet in Moominland'),
                  RDF::Statement(model.rdf_subject,
                                 predicate,
                                 'Moomin Midwinter'))
    true
  end
end

RSpec.shared_examples 'a model with core metadata' do
  subject(:model) { described_class.new }

  describe '#date_modified'
  describe '#date_uploaded'
  describe '#depositor'

  describe '#first_title' do
    it 'is nil when empty' do
      expect(model.first_title).to be_nil
    end

    it 'is a single title' do
      expect { model.title = ['Comet in Moominland', 'Moomin Midwinter'] }
        .to change { model.first_title }
        .to an_instance_of(String)
    end
  end

  it { is_expected.to have_editable_property(:title, RDF::Vocab::DC.title) }
end

RSpec.shared_examples 'a model with basic metadata' do
  subject(:model) { described_class.new }

  it_behaves_like 'a model with core metadata'

  it 'has singular properties' # label, relative_path, import_url
  it { is_expected.to have_editable_property(:bibliographic_citation, RDF::Vocab::DC.bibliographicCitation) }
  it { is_expected.to have_editable_property(:contributor, RDF::Vocab::DC11.contributor) }
  it { is_expected.to have_editable_property(:creator, RDF::Vocab::DC11.creator) }
  it { is_expected.to have_editable_property(:date_created, RDF::Vocab::DC.created) }
  it { is_expected.to have_editable_property(:description, RDF::Vocab::DC11.description) }
  it { is_expected.to have_editable_property(:identifier, RDF::Vocab::DC.identifier) }
  it { is_expected.to have_editable_property(:keyword, RDF::Vocab::DC11.relation) }
  it { is_expected.to have_editable_property(:language, RDF::Vocab::DC11.language) }
  it { is_expected.to have_editable_property(:license, RDF::Vocab::DC.rights) }
  it { is_expected.to have_editable_property(:publisher, RDF::Vocab::DC11.publisher) }
  it { is_expected.to have_editable_property(:related_url, RDF::RDFS.seeAlso) }
  it { is_expected.to have_editable_property(:resource_type, RDF::Vocab::DC.type) }
  it { is_expected.to have_editable_property(:rights_statement, RDF::Vocab::EDM.rights) }
  it { is_expected.to have_editable_property(:source, RDF::Vocab::DC.source) }
  it { is_expected.to have_editable_property(:subject, RDF::Vocab::DC11.subject) }

  describe '#based_near' do
    it 'builds as a location'
    it 'is controlled'
    it 'accepts nested attributes'
  end
end
