require 'rails_helper'

RSpec.describe 'catalog/_index_list_default', type: :view do
  let(:attributes) do
    { keyword:       ['moomin', 'snorkmaiden'],
      resource_type: ['Moomin'] }
  end

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

  # title appears in a different partial, not in the metadata listing
  it 'does not display undesired fields' do
    expect(rendered).not_to include 'title'
  end

  it 'displays desired fields' do
    expect(rendered)
      .to include('<span class="attribute-label h4">Keyword:</span>', 'keyword',
                  '<span class="attribute-label h4">Resource Type:</span>', 'resource_type')
  end
end
