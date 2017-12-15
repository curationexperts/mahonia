# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Autocomplete MeSH terms', :clean, mesh: true, js: true do
  let(:admin) { FactoryBot.create(:admin) }
  before do
    import_mesh_terms
    login_as admin
  end

  scenario 'autocompleting MeSH terms in the subject field on form' do
    visit '/concern/etds/new'
    expect(page).to have_content('Additional fields')
    click_on 'Additional fields'

    # Check that we get the correct autocompletion from QA
    find('#etd_subject').send_keys 'sulfameraz'
    expect(page).to have_content('Sulfamerazine')

    # Fill out the rest of the form
    find('ul.ui-autocomplete li.ui-menu-item', text: 'Sulfamerazine').click
    fill_in 'Title', with: 'MeSH Test'
    fill_in 'Creator', with: 'Creator'
    fill_in 'Keyword', with: 'Keyword'
    select 'In Copyright', from: 'Rights'
    find('body').click

    # Add a file
    click_link "Files" # switch tab
    expect(page).to have_content "Add files"
    within('span#addfiles') do
      attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')), visible: false)
    end
    expect(page).to have_content('Delete')

    # Submit the form
    expect(page).to have_selector('#with_files_submit')
    find('#with_files_submit').click

    # Check that the page has Sulfamerazine
    expect(page).to have_content 'Sulfamerazine'
    expect(page).to have_content 'MeSH Test'
    expect(page).to have_content 'In Copyright'
  end
end
