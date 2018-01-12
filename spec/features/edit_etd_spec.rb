# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Edit an OSHU ETD', :clean, js: true do
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }

  after { logout }
  context 'an admin user' do
    before do
      login_as admin
      AdminSet.find_or_create_default_admin_set_id
    end
    let(:etd) do
      FactoryBot.attributes_for(
        :moomins_thesis,
        user: admin,
        visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      )
    end

    scenario 'can edit all of the metadata of an Etd', :perform_enqueued, :datacite_api do
      ActiveJob::Base.queue_adapter.filter = [DataciteRegisterJob]

      visit("/concern/etds/new")
      expect(page).to have_content 'Add New Etd'
      click_link 'Files'
      within('#addfiles') do
        attach_file('files[]', "#{fixture_path}/files/pdf-sample.pdf", visible: false, wait: 10)
      end

      click_link 'Description'

      fill_in 'Creator', with: etd[:creator].first
      fill_in 'Keyword', with: etd[:keyword].first
      # term for rights URI set in factory
      select('No Known Copyright', from: 'Rights')

      click_link 'Additional fields'

      fill_in 'Title', with: etd[:title].first
      fill_in 'Description', with: etd[:description].first
      # term for license URI set in factory
      select('Creative Commons BY-SA Attribution-ShareAlike 4.0 International', from: 'License')
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

      click_on('Save')
      # wait until we have a record
      persisted_etd = Etd.where(title: "Edited Title") while persisted_etd.nil?
      click_on('Edit')

      sleep(2)
      fill_in 'Creator', with: "Edited Creator"
      fill_in 'Keyword', with: "Edited Keyword"
      # term for rights URI set in factory
      select('In Copyright', from: 'Rights')

      click_link 'Additional fields'

      fill_in 'Description', with: "Edited Description"
      # term for license URI set in factory
      select('Creative Commons BY-SA Attribution-ShareAlike 4.0 International', from: 'License')
      fill_in 'Subject', with: "Edited Subject"
      fill_in 'Language', with: "Edited Language"
      fill_in 'Identifier', with: "Edited Identifier"
      fill_in 'Related URL', with: "Edited Related Url"
      fill_in 'Source', with: "Edited Source"
      select(etd[:degree].last, from: 'Degree Name')
      select(etd[:department].last, from: 'Department')
      # There is only one institution, so to change it we have to select none, thereby removing it
      select("", from: 'Institution')
      fill_in 'ORCID', with: "Edited Orcid"
      select("Article", from: 'Document Type')

      select(etd[:school].last, from: 'School')
      fill_in 'Title', with: "Edited Title"
      # this seems to be a testing bug due to jobs needing to run to completion in order for record to have files associated with it, but the form should be valid when it's loaded.
      # TODO: confirm why files aren't here at this point in testing, possibly fix jobs and remove need to re-add files while editing to get valid form.
      click_link 'Files'

      within('#addfiles') do
        attach_file('files[]', "#{fixture_path}/files/pdf-sample.pdf", visible: false, wait: 10)
      end

      expect(find('#with_files_submit')).not_to be_disabled
      click_on('Save')

      sleep(2)
      expect(page).to have_content "Edited Title"
      expect(page).to have_content "Edited Creator"
      expect(page).to have_content "Edited Keyword"
      expect(page).to have_content "In Copyright"
      expect(page).to have_content "Edited Description"
      expect(page).to have_content "Edited Subject"
      expect(page).to have_content "Edited Language"
      expect(page).to have_content "Edited Identifier"
      expect(page).to have_content "Edited Related Url"
      expect(page).to have_content "Edited Source"
      expect(page).to have_content etd[:degree].last
      expect(page).to have_content etd[:department].last
      expect(page).not_to have_content "Institution"
      expect(page).to have_content "Edited Orcid"
      # document type is case-sensitive
      expect(page).to have_content "article"
      expect(page).to have_content etd[:school].last

      # destroy ETD
      Etd.last.delete
    end

    scenario 'can add an additional file to an Etd' do
      etd = FactoryBot.create(
        :moomins_thesis,
        user: admin,
        visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      )
      visit "concern/etds/#{etd.id}"
      click_link 'Edit'
      sleep(2)
      click_link 'Files'

      within('#addfiles') do
        attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')), visible: false)
      end

      find('#with_files_submit').click

      expect(page).to have_content('pdf-sample.pdf')
      # delete ETD
      Etd.find(etd.id.to_s).delete
    end

    scenario "can delete a file from an Etd", :perform_enqueued, :datacite_api do
      ActiveJob::Base.queue_adapter.filter = [DataciteRegisterJob, AttachFilesToWorkJob]
      # create an Etd, and add files to it
      etd = FactoryBot.create(
        :moomins_thesis,
        user: admin,
        visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      )
      visit("/concern/etds/new")

      click_link 'Files'
      within('span#addfiles') do
        page.attach_file('files[]', "#{fixture_path}/files/pdf-sample.pdf", visible: false, wait: 5)
      end
      click_link 'Description'
      fill_in 'Title', with: etd[:title].first
      fill_in 'Creator', with: etd[:creator].first
      fill_in 'Keyword', with: etd[:keyword].first
      # term for rights URI set in factory
      select('No Known Copyright', from: 'Rights')

      # give the browser time to enable button
      sleep(2)
      expect(find('#with_files_submit')).not_to be_disabled
      click_on('Save')
      # wait until we have a record
      persisted_etd = Etd.where(title: "Edited Title") while persisted_etd.nil?

      click_on("pdf-sample.pdf")
      accept_confirm { click_on("Delete This File") }

      expect(page).to have_content("The file has been deleted.")
      expect(page).to have_content('This Etd has no files associated with it. Click "edit" to add more files.')
      expect(Etd.find(etd.id.to_s).file_set?).to be false

      Etd.find(etd.id.to_s).delete
    end
  end
end
