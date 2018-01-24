# frozen_string_literal: true
require 'rails_helper'

RSpec.describe EtdIndexer do
  subject(:indexer) { described_class.new(etd) }
  let(:etd)         { FactoryGirl.build(:etd) }

  describe '#generate_solr_document' do
    let(:dates) { [Mahonia::EdtfLiteral.new('2999?'), '1999'] }
    let(:etd)   { FactoryGirl.build(:etd, date: dates) }

    it 'indexes EDTF datatypes' do
      expect(indexer.generate_solr_document)
        .to include('date_tesim' => contain_exactly('1999', '2999?'))
    end
  end

  describe '#rdf_service' do
    it 'has facetable fields' do
      expect(indexer.rdf_service.stored_and_facetable_fields)
        .to include(:date, :date_created, :date_label, :creator, :contributor,
                    :keyword, :subject, :language, :publisher, :rights_statement)
    end
  end
end
