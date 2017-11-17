require 'rails_helper'

RSpec.describe EtdIndexer do
  subject(:indexer) { described_class.new(etd) }
  let(:etd)         { FactoryGirl.build(:etd) }

  describe '#rdf_service' do
    it 'has facetable fields' do
      expect(indexer.rdf_service.stored_and_facetable_fields)
        .to include(:creator, :contributor, :date_label, :date_created,
                    :keyword, :subject, :language, :publisher,
                    :rights_statement)
    end
  end
end
