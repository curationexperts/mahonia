require 'rails_helper'

RSpec.describe Mahonia::BlacklightHelper, type: :helper, clean: true do
  describe '#snippit' do
    let(:document) { SolrDocument.new(document_attributes) }
    let(:references_field) { Settings.FIELDS.REFERENCES }
    context 'as a String' do
      let(:document_attributes) do
        {
          value: 'This is a really long string that should get truncated when it gets rendered'\
                 'in the index view to give a brief description of the contents of a particular document'\
                 'indexed into Solr'
        }
      end
      it 'truncates longer strings to 140 characters' do
        expect(helper.snippit(document).length).to eq 140
      end
      it 'truncated string ends with ...' do
        expect(helper.snippit(document)[-3..-1]).to eq '...'
      end
    end
    context 'as an Array' do
      let(:document_attributes) do
        {
          value: ['This is a really long string that should get truncated when it gets rendered'\
                  'in the index view to give a brief description of the contents of a particular document'\
                  'indexed into Solr']
        }
      end
      it 'truncates longer strings to 140 characters' do
        expect(helper.snippit(document).length).to eq 140
      end
      it 'truncated string ends with ...' do
        expect(helper.snippit(document)[-3..-1]).to eq '...'
      end
    end
    context 'as a multivalued Array' do
      let(:document_attributes) do
        {
          value: %w[short description]
        }
      end
      it 'uses both values' do
        expect(helper.snippit(document)).to eq 'short description'
      end
      it 'does not truncate' do
        expect(helper.snippit(document)[-3..-1]).not_to eq '...'
      end
    end
  end
  describe '#render_truncated_description' do
    let(:etd) { FactoryBot.create(:etd) }
    let(:description) { ['A long description that is quite long. Long long long long long long long long long long. Extremely extremely extremely long long long long long long long.'] }
    it 'has a "View More" button' do
      args = { value: description,
               document: { controller: 'hyrax/etds', id: etd.id, action: 'show' } }
      expect(Capybara.string(helper.render_truncated_description(args))).to have_link('View More')
    end
    it 'has an ellipsis' do
      args = { value: description,
               document: { controller: 'hyrax/etds', id: etd.id, action: 'show' } }
      expect(Capybara.string(helper.render_truncated_description(args))).to have_content('...')
    end
    it 'the text from the description' do
      args = { value: description,
               document: { controller: 'hyrax/etds', id: etd.id, action: 'show' } }
      expect(Capybara.string(helper.render_truncated_description(args))).to have_text('A long description')
    end
  end
end
