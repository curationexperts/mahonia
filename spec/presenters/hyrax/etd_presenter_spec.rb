require 'rails_helper'

RSpec.describe Hyrax::EtdPresenter, type: :presenter do
  subject(:presenter) { described_class.new(document, ability, request) }
  let(:ability)       { nil }
  let(:document)      { SolrDocument.new(etd.to_solr) }
  let(:etd)           { FactoryGirl.create(:etd, id: 'moomin_id') }
  let(:request)       { instance_double('Rack::Request', host: 'example.com') }

  describe '#export_as_ttl' do
    it 'has a title' do
      expect(presenter.export_as_ttl)
        .to include etd.class.properties['title'].predicate.to_base
    end
  end
end
