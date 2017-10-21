require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Access an Etd', :perform_enqueued, js: false do
  let(:etd) { FactoryGirl.create(:public_etd, pdf: pdf) }
  let(:pdf) { FactoryGirl.create(:pdf_upload) }

  # Only enqueue the ingest job, not charactarization.
  before { ActiveJob::Base.queue_adapter.filter = [IngestJob] }

  scenario 'downloading' do
    visit      "concern/etds/#{etd.id}"
    click_link "Download \"#{etd.representative.first_title}\""

    expect(page.response_headers['Content-Disposition']).to include 'attachment'
  end
end
