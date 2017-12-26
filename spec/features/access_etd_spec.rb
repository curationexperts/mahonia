# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Access an Etd', js: false do
  let(:etd) { FactoryGirl.create(:public_etd, pdf: pdf) }
  let(:pdf) { FactoryGirl.create(:pdf_upload) }

  # Only enqueue the ingest job, not charactarization.
  before { ActiveJob::Base.queue_adapter.filter = [IngestJob] }

  shared_examples 'open access to public etds' do
    scenario 'searching submitted public etd' do
      visit '/'

      fill_in 'Search OHSU Scholar Archive', with: etd.first_title
      click_button 'Go'

      within(:css, "li#document_#{etd.id}") do
        expect(page).to have_content etd.first_title
      end
    end

    context 'with ingested file', :perform_enqueued do
      scenario 'downloading is allowed for public etd' do
        visit      "concern/etds/#{etd.id}"
        click_link "Download \"#{etd.representative.first_title}\""

        expect(page.response_headers['Content-Disposition']).to include 'attachment'
      end
    end
  end

  shared_context 'restricted access to private etds' do
    let(:private_etd) { FactoryGirl.create(:etd, pdf: pdf) }

    scenario 'searching private etd is restricted' do
      visit '/'

      fill_in 'Search OHSU Scholar Archive', with: private_etd.first_title
      click_button 'Go'

      expect(page).not_to have_css("li#document_#{private_etd.id}")
    end

    scenario 'browsing to private etd is restricted' do
      visit "concern/etds/#{private_etd.id}"

      expect(page).not_to have_content private_etd.title
      # Hyrax doesn't seem to give a consistent error message!
      # expect(page).to have_content 'private'
      # expect(page).to have_content 'not authorized'
    end

    context 'with ingested file', :perform_enqueued do
      scenario 'downloading is restricted for private etds' do
        visit "concern/etds/#{private_etd.id}"
        expect(page).not_to have_content 'Download'
      end
    end
  end

  context 'as unauthenticated user' do
    before { logout }

    include_context 'open access to public etds'
    include_context 'restricted access to private etds'

    let(:institutional_etd) { FactoryGirl.create(:authenticated_etd, pdf: pdf) }

    scenario 'searching institutional etd is restricted' do
      visit '/'

      fill_in 'Search OHSU Scholar Archive', with: institutional_etd.first_title
      click_button 'Go'

      expect(page).not_to have_css("li#document_#{institutional_etd.id}")
    end

    scenario 'browsing to institutional etd is restricted' do
      visit "concern/etds/#{institutional_etd.id}"

      expect(page).not_to have_content institutional_etd.title
      # Hyrax doesn't seem to give a consistent error message!
      # expect(page).to have_content 'private'
      # expect(page).to have_content 'not authorized'
    end

    context 'with ingested file', :perform_enqueued do
      scenario 'downloading is restricted for institutional etds' do
        visit "concern/etds/#{institutional_etd.id}"
        expect(page).not_to have_content 'Download'
      end
    end
  end

  context 'as non-admin user' do
    let(:user) { FactoryBot.create(:user) }

    before { login_as user }
    after(:context) { logout }

    include_context 'open access to public etds'
    include_context 'restricted access to private etds'
  end

  context 'as admin user' do
    let(:user) { FactoryBot.create(:user) }

    before { login_as user }
    after(:context) { logout }

    include_context 'open access to public etds'
  end
end
