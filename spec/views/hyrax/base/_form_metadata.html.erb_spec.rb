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
