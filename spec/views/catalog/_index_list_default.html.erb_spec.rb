require 'rails_helper'

RSpec.describe 'catalog/_index_list_default', type: :view do
  let(:attributes) { { keyword: ['moomin', 'snorkmaiden'] } }
  let!(:document)  { SolrDocument.new(etd.to_solr) }
  let!(:etd)       { FactoryGirl.build(:etd, **attributes) }
  let!(:presenter) { instance_double('Blacklight::IndexPresenter') }

  before do
    # @todo Set index_presenter on the view in a more realistic way.
    #   does this belong in the controller view helpers?
    allow(view).to receive(:index_presenter).and_return(presenter)
    # @todo Build a more comprehensive IndexPresenter fake
    allow(presenter).to receive(:field_value) { |field| "A value for #{field}" }

    render 'catalog/index_list_default', document: document
  end

  # title appears in a different partial
  it 'does not display the title in the metadata' do
    expect(rendered).not_to include 'Title:'
  end

  it 'displays keywords' do
    expect(rendered).to include '<span class="attribute-label h4">Keyword:</span>'
  end
end
