require 'rails_helper'

RSpec.describe Hyrax::EtdPresenter, type: :presenter do
  subject(:presenter) { described_class.new(document, ability, request) }
  let(:ability)       { nil }
  let(:document)      { SolrDocument.new(etd.to_solr) }
  let(:etd)           { FactoryGirl.create(:etd, id: 'moomin_id', **attributes) }
  let(:request)       { instance_double('Rack::Request', host: 'example.com') }

  let(:attributes) do
    { title:         ['Moomin Title'],
      creator:       ['Tove Jansson'],
      resource_type: ['letter from moominpapa'] }
  end

  describe '#export_as_ttl' do
    let(:expected_fields) { [:title, :creator, :resource_type] }
    let(:properties) { etd.class.properties }

    it 'has expected predicates' do
      predicates =
        expected_fields.map { |f| properties[f.to_s].predicate.to_base }

      expect(presenter.export_as_ttl).to include(*predicates)
    end
  end
end
