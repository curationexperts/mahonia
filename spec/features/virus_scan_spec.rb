# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Virus Scanning', :clean, :js, :virus_scan do
  let(:admin) { FactoryBot.create(:admin) }
  before { login_as admin }
  after  { logout }

  let(:safe_path)  { "#{fixture_path}/files/pdf-sample.pdf" }
  let(:virus_path) { "#{fixture_path}/virus_check.txt" }

  scenario 'uploading a file with a virus', :perform_enqueued do
    ActiveJob::Base.queue_adapter.filter = [AttachFilesToWorkJob, IngestJob]
    visit('/concern/etds/new')
    click_link('Files')

    within('#addfiles') do
      attach_file('files[]', safe_path, visible: false, wait: 5)
      attach_file('files[]', virus_path, visible: false, wait: 5)
    end

    click_link('Description')
    fill_in 'Title', with: 'A Work with a Virus'
    fill_in 'Creator', with: 'Dmitri Ivanovsky'
    fill_in 'Keyword', with: 'pathogens'
    select('No Known Copyright', from: 'Rights')

    allow(Rails.logger).to receive(:error)

    click_on('Save')

    created_etd = Etd.find(current_url.split('/').last.split('?').first)

    expect(Rails.logger)
      .to have_received(:error)
      .with(/Virus.*virus_check\.txt/m)

    expect(created_etd.representative.title).to contain_exactly 'pdf-sample.pdf'

    # does not attach the virus file; deletes it from disk
    expect(created_etd.file_sets.count).to eq 1
    expect(Hyrax::UploadedFile.select { |f| f.file.file.exists? }.count).to eq 1
  end
end
