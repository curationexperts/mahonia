# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Autocomplete MeSH terms', mesh: true, js: true do
  let(:admin) { FactoryBot.create(:admin) }
  before do
    import_mesh_terms
    login_as admin
    ActiveFedora::Cleaner.clean!
    AdminSet.find_or_create_default_admin_set_id
  end

  scenario 'autocompleting MeSH terms in the subject field on form' do
    visit '/concern/etds/new'
    # Add a file first
    click_link "Files" # switch tab
    expect(page).to have_content "Add files"
    within('span#addfiles') do
      attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')), visible: false)
    end
    click_link "Description"

    expect(page).to have_content('Additional fields')
    click_on 'Additional fields'

    # Check that we get the correct autocompletion from QA
    find('#etd_subject').send_keys 'SuLFamerAZ'
    expect(page).to have_content('Sulfamerazine')

    # Fill out the rest of the form
    find('ul.ui-autocomplete li.ui-menu-item', text: 'Sulfamerazine').click
    fill_in 'Title', with: 'MeSH Test'
    fill_in 'Creator', with: 'Creator'
    fill_in 'Keyword', with: 'Keyword'
    select 'In Copyright', from: 'Rights'
    find('body').click

    # Submit the form
    expect(page).to have_selector('#with_files_submit')
    click_on('Save')

    # wait until we have a record
    persisted_etd = Etd.where(title: 'MeSH Test') while persisted_etd.nil?

    # Check that the page has Sulfamerazine
    expect(page).to have_content 'Sulfamerazine'
    expect(page).to have_content 'MeSH Test'
    expect(page).to have_content 'In Copyright'

    # clean up
    expect(page).to have_content('Delete')
    Etd.where(title_tesim: 'MeSH Test').first.delete
    expect(Etd.all.size).to eq 0
  end
end
