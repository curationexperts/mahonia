require 'rails_helper'

RSpec.describe Mahonia::CitationFormatter do
  subject(:formatter) { described_class.new(object: document) }
  let(:document)      { SolrDocument.new(etd.to_solr) }
  let(:etd)           { FactoryBot.build(:shannon_mit, id: 'shannon') }

  describe '#citation' do
    it 'has the authors' do
      expect(formatter.citation).to include 'Shannon, C. E.'
    end

    it 'has a title' do
      expect(formatter.citation).to include etd.first_title
    end

    it 'has the publication year' do
      expect(formatter.citation).to include etd.date.first
    end

    it 'has the publisher' do
      expect(formatter.citation).to include 'Scholar Archive'
    end

    it 'has the doi' do
      expect(formatter.citation).to include etd.identifier.first
    end

    it 'has the work id' do
      expect(formatter.citation).to include etd.id
    end

    context 'with multiple authors' do
      let(:etd) { FactoryBot.build(:shannon_weaver, id: 'shannon_weaver') }

      it 'has the authors' do
        expect(formatter.citation).to include 'Shannon, C. E.', 'Weaver, W.'
      end
    end

    context 'with bad bibtex' do
      let(:etd) { FactoryBot.build(:shannon_mit_bad_bibtex, id: 'shannon') }

      it 'has the authors' do
        expect(formatter.citation).to include etd.creator.first
      end

      it 'has a title' do
        expect(formatter.citation).to include etd.first_title
      end

      it 'has the publication year' do
        expect(formatter.citation).to include etd.date.first
      end

      it 'has the publisher' do
        expect(formatter.citation).to include 'Scholar Archive'
      end

      it 'has the doi' do
        expect(formatter.citation).to include etd.identifier.first
      end

      it 'has the work id' do
        expect(formatter.citation).to include etd.id
      end
    end

    context 'without an id' do
      let(:etd) { FactoryBot.build(:etd) }

      it 'does not error' do
        expect { formatter.citation }.not_to raise_error
      end
    end
  end
end
