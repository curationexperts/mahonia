require 'rails_helper'

RSpec.describe 'hyrax/base/_work_description.html.erb', type: :view do
  subject(:page) do
    render 'hyrax/base/work_description', presenter: presenter
    Capybara::Node::Simple.new(rendered)

    let(:ability)       { double }
    let(:presenter)     { Hyrax::EtdPresenter.new(solr_document, ability) }
    let(:solr_document) { SolrDocument.new(work.to_solr) }
    let(:work)          { FactoryGirl.build(:moomins_thesis) }

    it { is_expected.to have_show_field(:description).with_values(*work.description).and_label('Description') }
  end
end
