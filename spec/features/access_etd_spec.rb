# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Access an Etd', js: false do
  let(:etd)         { FactoryGirl.create(:public_etd, pdf: pdf) }
  let(:pdf)         { FactoryGirl.create(:pdf_upload) }
  let(:private_etd) { FactoryGirl.create(:etd, pdf: pdf) }

  scenario 'searching submitted ETDs' do
    visit '/'

    fill_in 'Search Hyrax', with: etd.first_title
    click_button 'Go'

    within(:css, "li#document_#{etd.id}") do
      expect(page).to have_content etd.first_title
    end
  end

  context 'with ingested file', :perform_enqueued do
    # Only enqueue the ingest job, not charactarization.
    before { ActiveJob::Base.queue_adapter.filter = [IngestJob] }

    scenario 'downloading' do
      visit      "concern/etds/#{etd.id}"
      click_link "Download \"#{etd.representative.first_title}\""

      expect(page.response_headers['Content-Disposition']).to include 'attachment'
    end

    scenario 'downloading restricted' do
      visit "concern/etds/#{private_etd.id}"
      expect(page).not_to have_content 'Download'
    end
  end
end
