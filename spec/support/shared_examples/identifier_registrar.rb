RSpec.shared_examples 'an IdentifierRegistrar' do
  subject(:registrar) { described_class.new(builder: builder) }
  let(:abstract)      { described_class == Mahonia::IdentifierRegistrar }
  let(:builder)       { instance_double(Mahonia::IdentifierBuilder, build: 'moomin') }
  let(:object)        { instance_double(Etd, id: 'moomin_id') }

  it { is_expected.to have_attributes(builder: builder) }

  describe '.for' do
    it 'raises an error when a fake registrar type is passes' do
      expect { described_class.for(:NOT_A_REAL_TYPE, builder: builder) }
        .to raise_error ArgumentError
    end

    it 'chooses the right registrar type' do
      expect(described_class.for(:datacite, builder: builder))
        .to be_a Mahonia::DataciteRegistrar
    end
  end

  describe '#register!' do
    it 'creates an identifier record' do
      skip if abstract
      expect(registrar.register!(object: object).identifier)
        .to respond_to :to_str
    end
  end
end
