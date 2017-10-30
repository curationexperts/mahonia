require 'rails_helper'

RSpec.describe SolrDocument do
  subject(:solr_document) { described_class.new(etd.to_solr) }
  let(:etd)               { FactoryGirl.build(:etd) }

  describe '#date_label' do
    it 'matches the model labels' do
      expect(solr_document.date_label).to be_nil
    end

    context 'with labels' do
      let(:date_labels) { ['Winter in Moomin Valley'] }
      let(:etd)         { FactoryGirl.build(:etd, date_label: date_labels) }

      it 'matches the model labels' do
        expect(solr_document.date_label).to eq date_labels
      end
    end
  end
end
