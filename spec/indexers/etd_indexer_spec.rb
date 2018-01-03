# frozen_string_literal: true
require 'rails_helper'

RSpec.describe EtdIndexer do
  subject(:indexer) { described_class.new(etd) }
  let(:etd)         { FactoryGirl.build(:etd) }

  describe '#rdf_service' do
    it 'has facetable fields' do
      expect(indexer.rdf_service.stored_and_facetable_fields)
        .to include(:date, :date_created, :date_label, :creator, :contributor,
                    :keyword, :subject, :language, :rights_statement)
    end
  end
end
