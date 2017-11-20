require 'rails_helper'

RSpec.describe Mahonia::DataciteRegistrar do
  subject(:registrar) { described_class.new }
  let(:model)         { :REPLACE_ME_WITH_A_MODEL }

  it_behaves_like 'an IdentifierRegistrar'

  describe '#builder' do
    it 'has a default bulider' do
      expect(registrar.builder).to be_a Mahonia::DataciteDoiBuilder
    end
  end

  describe '#register!' do
    it 'registers a datacite id'
  end
end
