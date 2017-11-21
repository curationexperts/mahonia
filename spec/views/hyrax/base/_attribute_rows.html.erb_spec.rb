# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'hyrax/base/_attribute_rows.html.erb', type: :view do
  subject(:page) do
    render 'hyrax/base/attribute_rows', presenter: presenter
    Capybara::Node::Simple.new(rendered)
  end

  let(:ability)       { double }
  let(:presenter)     { Hyrax::EtdPresenter.new(solr_document, ability) }
  let(:solr_document) { SolrDocument.new(work.to_solr) }
  let(:work)          { FactoryGirl.build(:moomins_thesis) }

  it { is_expected.to have_show_field(:creator).with_values(*work.creator).and_label('Creator') }
  # underspecify date values (they aren't necessarily sensible for all Date/DateTime values)
  it { is_expected.to have_show_field(:date_created).with_label('Date created') }
  it { is_expected.to have_show_field(:date).with_values(*work.date).and_label('Date') }
  it { is_expected.to have_show_field(:date_label).with_values(*work.date_label).and_label('Date label') }
  it { is_expected.to have_show_field(:degree).with_values(*work.degree).and_label('Degree Name') }
  it { is_expected.to have_show_field(:department).with_values(*work.department).and_label('Department') }
  it { is_expected.to have_show_field(:school).with_values(*work.school).and_label('School') }
  it { is_expected.to have_show_field(:institution).with_values(*work.institution).and_label('Institution') }
  it { is_expected.to have_show_field(:keyword).with_values(*work.keyword).and_label('Keyword') }
  it { is_expected.to have_show_field(:language).with_values(*work.language).and_label('Language') }
  it { is_expected.to have_show_field(:orcid_id).with_values(*work.orcid_id).and_label('ORCID') }
  it { is_expected.to have_show_field(:resource_type).with_values(*work.resource_type).and_label('Document type') }
  it { is_expected.to have_show_field(:rights_statement).with_values('No Known Copyright').and_label('Rights') }
  it { is_expected.to have_show_field(:source).with_values(*work.source).and_label('Source') }
  it { is_expected.to have_show_field(:subject).with_values(*work.subject).and_label('Subject') }

  it { is_expected.not_to have_show_field(:rights_note) }

  # @todo Hyrax hard codes license outside the _attribute_rows partial. We
  #   should normalize hyrax behavior and make it configurable. In the
  #   meanwhile, is there a cleaner way to test this?
  # it { is_expected.to have_show_field(:license).with_values(*attributes[:license]).and_label('License') }
  it 'shows the license' do
    node =
      Capybara::Node::Simple.new(presenter.attribute_to_html(:license, render_as: :license))
    expect(node).to have_show_field(:license)
      .with_values('Creative Commons BY-SA Attribution-ShareAlike 4.0 International').and_label('License')
  end

  it 'shows the citation' do
    expect(page).to have_css('.citation', text: work.title.first)
  end
end
