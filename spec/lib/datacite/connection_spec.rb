# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Datacite::Connection do
  subject(:connection) { described_class.new }
  let(:configuration)  { Datacite::Configuration.instance }

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
    let(:identifier) { "#{configuration.prefix}/moomin" }

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
end
