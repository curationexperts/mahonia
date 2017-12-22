# frozen_string_literal: true
require 'rails_helper'
require 'fakes/fake_datacite_connection'

RSpec.describe Mahonia::DataciteRegistrar do
  subject(:registrar) { described_class.new(connection: connection) }
  let(:model)         { FactoryBot.build_stubbed(:moomins_thesis, id: identifier) }
  let(:test_prefix)   { Datacite::Configuration.instance.prefix }
  let(:connection)    { FakeDataciteConnection.new }
  let(:doi)           { "#{test_prefix}/#{identifier}" }
  let(:identifier)    { 'moomin_id' }

  let(:mapped_hash) do
    { identifier:       doi,
      creator:          model.creator,
      publication_year: model.date_uploaded.year,
      title:            model.title }
  end

  it_behaves_like 'an IdentifierRegistrar' do
    before { registrar.connection = connection }
  end

  describe '#builder' do
    it 'has a default bulider' do
      expect(registrar.builder).to have_attributes prefix: test_prefix
    end
  end

  describe '#record_for' do
    context 'with stripped down schema' do
      let(:model) { instance_double(Etd, id: identifier) }

      it 'builds a record with only the identifer' do
        expect(registrar.record_for(object: model))
          .to have_attributes identifier: doi
      end
    end

    it 'builds a record with metadata mapped to datacite' do
      expect(registrar.record_for(object: model))
        .to have_attributes(**mapped_hash)
    end
  end

  describe '#register!' do
    context 'with no id' do
      let(:model) { instance_double(Etd, id: nil) }

      it 'raises an ArgumentError' do
        expect { registrar.register!(object: model) }
          .to raise_error ArgumentError
      end
    end

    context 'with stripped down schema' do
      let(:model) { instance_double(Etd, id: identifier) }

      it 'registers a datacite id' do
        expect(registrar.register!(object: model))
          .to have_attributes identifier: doi
      end
    end

    it 'registers a datacite id with attributes' do
      expect(registrar.register!(object: model))
        .to have_attributes(**mapped_hash)
    end

    it 'sends a request to update the handle registration' do
      expect { registrar.register!(object: model) }
        .to change { registrar.connection.registered } # spy
        .to include(doi => 'http://localhost:3000/concern/etds/moomin_id')
    end
  end
end
