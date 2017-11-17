require 'rails_helper'

RSpec.describe 'catalog/_index_list_default', type: :view do
  subject(:page)   { Capybara::Node::Simple.new(rendered) }
  let!(:document)  { SolrDocument.new(etd.to_solr) }
  let!(:etd)       { FactoryGirl.build(:moomins_thesis) }
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
    is_expected.not_to list_index_fields('Title', 'Language', 'Source',
                                         'Identifier', 'Rights Note', 'Rights',
                                         'License')
  end

  it 'displays desired fields' do
    is_expected.to list_index_fields('Creator', 'Date Label', 'Date Modified',
                                     'Date Uploaded', 'Degree Name', 'Keyword',
                                     'Document Type', 'Subject')
  end
end
