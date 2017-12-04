# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'hyrax/base/_metadata.html.erb', type: :view do
  subject(:page) do
    render 'hyrax/base/metadata.html.erb', presenter: presenter
    Capybara::Node::Simple.new(rendered)
  end

  let(:ability)       { double }
  let(:presenter)     { Hyrax::EtdPresenter.new(solr_document, ability) }
  let(:solr_document) { SolrDocument.new(work.to_solr) }
  let(:work)          { FactoryGirl.build(:moomins_thesis) }

  describe 'embargos' do
    let(:work) { FactoryGirl.build(:embargoed_etd) }
    let(:date) { work.embargo_release_date.to_date.to_formatted_s(:standard) }

    it { is_expected.to have_show_field(:embargo_release_date).with_values(date).and_label('Available for Download Date') }
  end
end
