# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create an OSHU ETD', :clean, js: true do
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:etd) do
    FactoryBot.attributes_for(
      :moomins_thesis,
      user: admin,
      visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    )
  end

  after { logout }

  context 'an admin user' do
    before do
      login_as admin
      AdminSet.find_or_create_default_admin_set_id
    end

    scenario 'can create an Etd', :perform_enqueued, :datacite_api do
      ActiveJob::Base.queue_adapter.filter = [DataciteRegisterJob, AttachFilesToWorkJob]

      visit("/concern/etds/new")

      expect(page).to have_content 'Add New Etd'
      click_link('Files')
      within('#addfiles') do
        attach_file('files[]', "#{fixture_path}/files/pdf-sample.pdf", visible: false, wait: 10)
      end

      click_link('Description')
      fill_in 'Title', with: etd[:title].first
      fill_in 'Creator', with: etd[:creator].first
      fill_in 'Keyword', with: etd[:keyword].first
      # term for rights URI set in factory
      select('No Known Copyright', from: 'Rights')

      click_link 'Additional fields'
      fill_in 'Description', with: etd[:description].first
      # term for license URI set in factory
      select('Creative Commons BY-SA Attribution-ShareAlike 4.0 International', from: 'License')
      fill_in 'EDTF Date', with: etd[:date].first
      fill_in 'Publisher', with: etd[:publisher].first
      fill_in 'Date Created', with: etd[:date_created].first
      fill_in 'Subject', with: etd[:subject].first
      fill_in 'Language', with: etd[:language].first
      fill_in 'Identifier', with: etd[:identifier].first
      fill_in 'Related URL', with: etd[:related_url].first
      fill_in 'Source', with: etd[:source].first
      select(etd[:degree].first, from: 'Degree Name')
      select(etd[:department].first, from: 'Department')
      select(etd[:institution].first, from: 'Institution')
      fill_in 'ORCID', with: etd[:orcid_id].first
      select(etd[:resource_type].first, from: 'Document Type')
      fill_in 'Rights note', with: etd[:rights_note].first
      select(etd[:school].first, from: 'School')

      # give the browser time to enable button
      sleep(2)
      expect(find('#with_files_submit')).not_to be_disabled

      click_on('Save')
      # wait until we have a record
      persisted_etd = Etd.where(title: etd[:title].first) while persisted_etd.nil?

      # ensure the EDTF date is typed
      expect(persisted_etd.first)
        .to have_attributes(date: contain_exactly(*etd[:date].map(&:object)))

      expect(page).to have_content etd[:title].first
      expect(page).to have_content etd[:creator].first
      expect(page).to have_content etd[:keyword].first
      # rights
      expect(page).to have_content 'No Known Copyright'
      expect(page).to have_content etd[:description].first
      # license
      expect(page).to have_content 'Creative Commons BY-SA Attribution-ShareAlike 4.0 International'
      expect(page).to have_content etd[:publisher].first
      expect(page).to have_content etd[:date].first
      expect(page).to have_content etd[:subject].first
      expect(page).to have_content etd[:language].first
      # Identifier sets DOI
      expect(page).to have_css('.identifier', text: '10.5072')
      expect(page).to have_content etd[:related_url].first
      expect(page).to have_content etd[:degree].first
      expect(page).to have_content etd[:department].first
      expect(page).to have_content etd[:institution].first
      expect(page).to have_content etd[:orcid_id].first
      expect(page).to have_content etd[:source].first
      expect(page).to have_content %r{#{etd[:resource_type].first}}i
      expect(page).to have_content etd[:school].first
    end
  end

  # Non admin users should not be able to create a new work

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
  end
end
