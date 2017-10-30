require 'rails_helper'

RSpec.describe 'catalog/_index_list_default', type: :view do
  subject(:page) { Capybara::Node::Simple.new(rendered) }

  let(:attributes) do
    { creator:       ['Tove Jansson'],
      degree:        ['M.Phil.'],
      identifier:    ['Moomin_123'],
      date_label:    ['Winter in Moomin Valley'],
      keyword:       ['moomin', 'snorkmaiden'],
      resource_type: ['letter from moominpapa'],
      source:        ['Too-Ticky'],
      rights_note:   ['for moomin access only'],
      subject:       ['Moomins', 'Snorks'],
      language:      ['en-US'] }
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
    is_expected.not_to list_index_fields('Title', 'Language', 'Source', 'Identifier', 'Rights Note')
  end

  it 'displays desired fields' do
    is_expected.to list_index_fields('Creator', 'Date Label', 'Degree Name',
                                     'Keyword', 'Document Type', 'Subject')
  end
end
