# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Datacite::Connection do
  subject(:connection) { described_class.new }
  let(:configuration)  { Datacite::Configuration.instance }

  it do
    is_expected
      .to have_attributes(configuration:   Datacite::Configuration.instance,
                          connection:      an_instance_of(Faraday::Connection),
                          content_builder: an_instance_of(Datacite::XmlBuilder))
  end

  # rubocop:disable RSpec/VerifiedDoubles
  # We are happy to use an unverified double, since we aren't picky the metadata
  # behavior as long as it responds to identifier
  describe '#create', :datacite_api do
    let(:identifier) { "#{configuration.prefix}/moomin" }
    let(:metadata)   { double(identifier: identifier, title: ['Comet in Moominland']) }

    it 'returns a record with the same identifier' do
      expect(connection.create(metadata: metadata).identifier).to eq identifier
    end
  end
  # rubocop:enable RSpec/VerifiedDoubles
end
