require 'rails_helper'

RSpec.describe Mahonia::IdentifierRegistrar do
  describe '.for' do
    it 'raises an error when a fake registrar type is passes' do
      expect { described_class.for(:NOT_A_REAL_TYPE) }.to raise_error ArgumentError
    end

    it 'chooses the right registrar type' do
      expect(described_class.for(:datacite)).to be_a Mahonia::DataciteRegistrar
    end
  end
end
