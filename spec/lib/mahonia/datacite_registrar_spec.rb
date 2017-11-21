require 'rails_helper'

RSpec.describe Mahonia::DataciteRegistrar do
  subject(:registrar) { described_class.new }
  let(:model)         { instance_double(Etd, id: 'moomin_id') }
  let(:test_prefix)   { Datacite::Configuration.instance.prefix }

  it_behaves_like 'an IdentifierRegistrar'

  describe '#builder' do
    it 'has a default bulider' do
      expect(registrar.builder).to have_attributes prefix: test_prefix
    end
  end

  describe '#register!' do
    it 'registers a datacite id' do
      expect(registrar.register!(object: model))
        .to have_attributes identifier: test_prefix + '/moomin_id'
    end
  end
end
