require 'rails_helper'

RSpec.describe Hyrax::EtdPresenter, type: :presenter do
  subject(:presenter) { described_class.new(document, ability, request) }
  let(:ability)       { nil }
  let(:document)      { SolrDocument.new(etd.to_solr) }
  let(:etd)           { FactoryGirl.create(:moomins_thesis, id: 'moomin_id') }
  let(:request)       { instance_double('Rack::Request', host: 'example.com') }

  describe '#citation' do
    it 'gives a citation string' do
      expect(presenter.citation).to include etd.title.first
    end
  end

  describe '#export_as_ttl' do
    let(:expected_fields) do
      [:creator, :date, :date_created, :date_label, :date_modified,
       :date_uploaded, :degree, :department, :description, :identifier,
       :institution, :license, :orcid_id, :title, :resource_type,
       :rights_note, :rights_statement, :school, :source, :subject]
    end

    let(:properties) { etd.class.properties }

    it 'has expected predicates' do
      predicates =
        expected_fields.map { |f| properties[f.to_s].predicate.to_base }

      expect(presenter.export_as_ttl).to include(*predicates)
    end
  end
end
