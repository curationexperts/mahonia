# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Mahonia::IdentifierDispatcher do
  subject(:dispatcher) { described_class.new(registrar: fake_registrar.new) }
  let(:identifier)     { 'moomin/123/abc' }
  let(:object)         { FactoryBot.build(:etd) }

  let(:fake_registrar) do
    Class.new do
      def initialize(*); end

      def register!(*)
        Struct.new(:identifier).new('moomin/123/abc')
      end
    end
  end

  shared_examples 'performs identifier assignment' do |method|
    it 'returns the same object' do
      expect(dispatcher.public_send(method, object: object)).to eql object
    end

    it 'assigns to the identifier attribute by default' do
      dispatcher.public_send(method, object: object)
      expect(object.identifier).to contain_exactly(identifier)
    end

    it 'assigns to specified attribute when requested' do
      dispatcher.public_send(method, object: object, attribute: :keyword)
      expect(object.keyword).to contain_exactly(identifier)
    end
  end

  it 'has a registrar' do
    expect(dispatcher.registrar).to be_a fake_registrar
  end

  describe '.for' do
    it 'chooses the right registrar type' do
      expect(described_class.for(:datacite).registrar)
        .to be_a Mahonia::DataciteRegistrar
    end

    it 'raises an error when a fake registrar type is passes' do
      expect { described_class.for(:NOT_A_REAL_TYPE) }
        .to raise_error ArgumentError
    end
  end

  describe '#assign_for' do
    include_examples 'performs identifier assignment', :assign_for
  end

  describe '#assign_for!' do
    include_examples 'performs identifier assignment', :assign_for!

    it 'saves the object' do
      expect { dispatcher.assign_for!(object: object) }
        .to change { object.new_record? }
        .from(true)
        .to(false)
    end
  end
end
