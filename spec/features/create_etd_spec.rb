# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create and edit an OSHU ETD', js: false do
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:etd) do
    FactoryBot.attributes_for(
      :moomins_thesis,
      user: admin,
      visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    )
  end
  let(:editing_etd) do
    FactoryBot.create(
      :moomins_thesis,
      user: admin,
      visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    )
  end
  after { logout }

  context 'an admin user' do
    before { login_as admin }

    scenario 'can create an Etd', :perform_enqueued, :datacite_api do
      ActiveJob::Base.queue_adapter.filter = [DataciteRegisterJob]

      visit '/dashboard'
      click_link 'Works'
      click_link 'Add new work'

      expect(page).to have_content 'Add New Etd'
      fill_in 'Title', with: etd[:title].first
      fill_in 'Creator', with: etd[:creator].first
      fill_in 'Keyword', with: etd[:keyword].first
      # term for rights URI in hyrax basic metadata factory
      select('No Known Copyright', from: 'Rights')

      click_link 'Additional fields'

      fill_in 'Description', with: etd[:description].first
      # term for license URI in hyrax basic metadata factory
      select('Creative Commons BY-SA Attribution-ShareAlike 4.0 International', from: 'License')
      fill_in 'Date Created', with: etd[:date_created].first
      fill_in 'Subject', with: etd[:subject].first
      fill_in 'Language', with: etd[:language].first
      fill_in 'Identifier', with: etd[:identifier].first
      fill_in 'Source', with: etd[:source].first
      select(etd[:resource_type].first, from: 'Document Type')

      click_link 'Files'

      within('#addfiles') do
        attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')))
      end

      find('#with_files_submit').click

      expect(page).to have_content etd[:title].first
      expect(page).to have_content etd[:creator
      ].first
      expect(page).to have_content etd[:keyword].first
      # rights
      expect(page).to have_content 'No Known Copyright'
      expect(page).to have_content etd[:description].first
      # license
      expect(page).to have_content 'Creative Commons BY-SA Attribution-ShareAlike 4.0 International'
      expect(page).to have_content etd[:subject].first
      expect(page).to have_content etd[:language].first
      # Identifier sets DOI
      expect(page).to have_css('.identifier', text: '10.5072')
      expect(page).to have_content etd[:source].first
    end

    scenario 'can edit an Etd' do
      visit "concern/etds/#{editing_etd.id}"
      click_link 'Edit'

      new_title   = 'Finn Family Moomintroll'
      new_keyword = 'moomin'

      fill_in 'Title',   with: new_title
      fill_in 'Keyword', with: new_keyword
      find('#with_files_submit').click

      expect(page).to have_content(new_title, new_keyword)
    end
  end

  # Non admin users should not be able to create a new work or to edit any works

  context "a non-admin user" do
    before do
      login_as user
    end
    scenario "cannot create a work" do
      expect(user.admin?).to eq(false)
      visit '/dashboard'
      click_link 'Works'
      expect(page).not_to have_content('Add new work')
      visit '/concern/etds/new'
      expect(page).to have_content('You are not authorized to access this page.')
    end
    scenario "cannot edit a work" do
      visit "/concern/etds/#{editing_etd.id}"
      expect(page).not_to have_content('Edit')
      visit "/concern/etds/#{editing_etd.id}/edit"
      expect(page).to have_content('Unauthorized')
    end
  end
end
