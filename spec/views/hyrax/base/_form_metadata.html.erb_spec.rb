require 'rails_helper'

RSpec.describe 'hyrax/base/_form_metadata.html.erb', type: :view do
  let(:ability) { double }
  let(:work) { FactoryGirl.build(:etd) }
  let(:form) { Hyrax::EtdForm.new(work, ability, controller) }

  let(:form_template) do
    %(
      <%= simple_form_for [main_app, @form] do |f| %>
        <%= render "hyrax/base/form_metadata", f: f %>
      <% end %>
     )
  end

  let(:page) do
    assign(:form, form)
    render inline: form_template
    Capybara::Node::Simple.new(rendered)
  end

  it "renders the additional fields button" do
    expect(page).to have_content('Additional fields')
  end

  describe 'form fields' do
    let(:license_uris) do
      ['https://creativecommons.org/licenses/by/4.0/',
       'https://creativecommons.org/licenses/by-sa/4.0/',
       'https://creativecommons.org/licenses/by-nd/4.0/',
       'https://creativecommons.org/licenses/by-nc/4.0/',
       'https://creativecommons.org/licenses/by-nc-nd/4.0/',
       'https://creativecommons.org/licenses/by-nc-sa/4.0/',
       'http://creativecommons.org/publicdomain/zero/1.0/',
       'http://creativecommons.org/publicdomain/mark/1.0/']
    end

    let(:rights_uris) do
      ['http://rightsstatements.org/vocab/InC/1.0/',
       'http://rightsstatements.org/vocab/InC-OW-EU/1.0/',
       'http://rightsstatements.org/vocab/InC-NC/1.0/',
       'http://rightsstatements.org/vocab/InC-RUU/1.0/',
       'http://rightsstatements.org/vocab/NoC-CR/1.0/',
       'http://rightsstatements.org/vocab/NoC-NC/1.0/',
       'http://rightsstatements.org/vocab/NoC-OKLR/1.0/',
       'http://rightsstatements.org/vocab/NoC-US/1.0/',
       'http://rightsstatements.org/vocab/CNE/1.0/',
       'http://rightsstatements.org/vocab/UND/1.0/',
       'http://rightsstatements.org/vocab/NKC/1.0/']
    end

    it 'has titles' do
      expect(page)
        .to have_multivalued_field(:title)
        .on_model(work.class)
        .with_label 'Title'
    end

    it 'has creators' do
      expect(page)
        .to have_multivalued_field(:creator)
        .on_model(work.class)
        .with_label 'Creator'
    end

    it 'has date labels' do
      expect(page)
        .to have_multivalued_field(:date_label)
        .on_model(work.class)
        .with_label 'Date label'
    end

    it 'has degree' do
      expect(page).to have_form_field(:degree)
        .as_single_valued.on_model(work.class)
        .with_label('Degree Name')
        .with_options('D.N.P.', 'M.A.', 'M.B.I.', 'M.M.I.', 'M.N.', 'M.N.A.',
                      'M.P.H.', 'M.S.', 'M.S.N.', 'Ph.D.')
    end

    it 'has school' do
      expect(page).to have_form_field(:school)
        .as_single_valued.on_model(work.class)
        .with_label('School')
        .with_options('School of Dentistry', 'School of Medicine', 'School of Nursing', 'School of Public Health')
    end

    it 'has identifier' do
      expect(page)
        .to have_form_field(:identifier)
        .on_model(work.class)
        .with_label 'Identifier'
    end

    it 'has institution' do
      expect(page)
        .to have_form_field(:institution)
        .as_single_valued.on_model(work.class)
        .with_label('Institution')
        .with_options('OHSU')
    end

    it 'has keywords' do
      expect(page)
        .to have_multivalued_field(:keyword)
        .on_model(work.class)
        .with_label 'Keyword'
    end

    it 'has language' do
      expect(page)
        .to have_multivalued_field(:language)
        .on_model(work.class)
        .with_label 'Language'
    end

    it 'has licenses' do
      expect(page).to have_form_field(:license)
        .as_single_valued
        .on_model(work.class)
        .with_label('License')
        .and_options(*license_uris)
    end

    it 'has orcid id' do
      expect(page)
        .to have_form_field(:orcid_id)
        .on_model(work.class)
        .with_label('ORCID')
    end

    it 'has resource_types' do
      expect(page)
        .to have_multivalued_field(:resource_type)
        .on_model(work.class)
        .with_label('Document Type')
        .and_options('article', 'capstone', 'dissertation', 'portfolio', 'thesis')
    end

    it 'has rights notes' do
      expect(page)
        .to have_multivalued_field(:rights_note)
        .on_model(work.class)
        .with_label('Rights note')
    end

    it 'has rights_statements' do
      expect(page).to have_form_field(:rights_statement)
        .on_model(work.class)
        .as_single_valued
        .with_label('Rights')
        .and_options(*rights_uris)
    end

    it 'has sources' do
      expect(page)
        .to have_multivalued_field(:source)
        .on_model(work.class)
        .with_label 'Source'
    end

    it 'has subjects' do
      expect(page)
        .to have_multivalued_field(:subject)
        .on_model(work.class)
        .with_label 'Subject'
    end
  end
end
