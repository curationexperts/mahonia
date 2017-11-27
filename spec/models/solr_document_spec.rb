# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SolrDocument do
  subject(:solr_document) { described_class.new(etd.to_solr) }
  let(:etd)               { FactoryGirl.build(:etd) }

  describe '#date' do
    it 'is nil when empty' do
      expect(solr_document.date).to be_nil
    end

    context 'with dates' do
      let(:date) { ['199?'] }
      let(:etd)  { FactoryGirl.build(:etd, date: date) }

      it 'matches the model dates' do
        expect(solr_document.date).to contain_exactly(*date)
      end
    end
  end

  describe '#date_label' do
    it 'is nil when empty' do
      expect(solr_document.date_label).to be_nil
    end

    context 'with labels' do
      let(:date_labels) { ['Winter in Moomin Valley'] }
      let(:etd)         { FactoryGirl.build(:etd, date_label: date_labels) }

      it 'matches the model labels' do
        expect(solr_document.date_label).to contain_exactly(*date_labels)
      end
    end
  end

  describe '#degree' do
    it 'is nil when empty' do
      expect(solr_document.degree).to be_nil
    end

    context 'with labels' do
      let(:degrees) { ['M.Phil.'] }
      let(:etd)     { FactoryGirl.build(:etd, degree: degrees) }

      it 'matches the model labels' do
        expect(solr_document.degree).to contain_exactly(*degrees)
      end
    end
  end

  describe '#department' do
    it 'is nil when empty' do
      expect(solr_document.department).to be_nil
    end

    context 'with labels' do
      let(:departments) { ['Coin Collecting'] }
      let(:etd)         { FactoryGirl.build(:etd, department: departments) }

      it 'matches the model labels' do
        expect(solr_document.department).to contain_exactly(*departments)
      end
    end
  end

  describe '#orcid_id' do
    it 'is nil when empty' do
      expect(solr_document.degree).to be_nil
    end

    context 'with orcids' do
      let(:orcids) { ['0000-0001-2345-6789'] }
      let(:etd)    { FactoryGirl.build(:etd, orcid_id: orcids) }

      it 'matches the model orcids' do
        expect(solr_document.orcid_id).to contain_exactly(*orcids)
      end
    end
  end

  describe '#school' do
    it 'is nil when empty' do
      expect(solr_document.school).to be_nil
    end

    context 'with labels' do
      let(:schools) { ['School of Dentistry'] }
      let(:etd)     { FactoryGirl.build(:etd, school: schools) }

      it 'matches the model labels' do
        expect(solr_document.school).to contain_exactly(*schools)
      end
    end
  end
end
