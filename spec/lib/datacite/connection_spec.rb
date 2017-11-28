# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Datacite::Connection do
  subject(:connection) { described_class.new }
  let(:configuration)  { Datacite::Configuration.instance }
  let(:identifier)     { "#{configuration.prefix}/moomin" }

  # rubocop:disable RSpec/VerifiedDoubles
  # We are happy to use an unverified double, since we aren't picky the metadata
  # behavior as long as it responds to identifier
  let(:metadata) { double(identifier: identifier, title: ['Comet in Moominland']) }
  # rubocop:enable RSpec/VerifiedDoubles

  it do
    is_expected
      .to have_attributes(configuration:   Datacite::Configuration.instance,
                          connection:      an_instance_of(Faraday::Connection),
                          content_builder: an_instance_of(Datacite::XmlBuilder))
  end

  describe '#create', :datacite_api do
    it 'returns a record with the same identifier' do
      expect(connection.create(metadata: metadata).identifier).to eq identifier
    end

    context 'with invalid authentication' do
      subject(:connection) { described_class.new(configuration: configuration) }

      let(:configuration) do
        instance_double(Datacite::Configuration,
                        domains:  Datacite::Configuration.instance.domains,
                        host:     Datacite::Configuration.instance.host,
                        login:    'FAKE LOGIN',
                        password: 'FAKE PASSWORD',
                        prefix:   Datacite::Configuration.instance.prefix)
      end

      it 'raises Unauthorized' do
        expect { connection.create(metadata: metadata) }
          .to raise_error described_class::Error, /401/
      end
    end
  end

  describe '#get', :datacite_api do
    context 'when the record exists' do
      before { connection.create(metadata: metadata) }

      it 'retrieves the record' do
        expect(connection.get(metadata: metadata))
          .to have_attributes identifier: identifier
      end
    end

    context 'with an unregistered identifier' do
      let(:identifier) { "#{configuration.prefix}/#{SecureRandom.uuid}" }

      it 'responds 404 Not Found' do
        expect { connection.get(metadata: metadata) }
          .to raise_error described_class::Error, /404/
      end
    end
  end
end
