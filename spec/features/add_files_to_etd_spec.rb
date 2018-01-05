# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Maintain Representative Media Settings', js: true do
  let(:etd) { FactoryBot.create(:public_etd, jpg: jpg) }
  let(:jpg) { FactoryBot.create(:jpg_upload) }

  let(:admin) { FactoryBot.create(:admin) }
  before do
    login_as admin
    ActiveFedora::Cleaner.clean!
    AdminSet.find_or_create_default_admin_set_id
  end

  scenario "Adding a pdf to an Etd doesn't change its representative jpg" do
    visit "concern/etds/#{etd.id}"

    # a normal Etd shows thumbnail of representative media
    expect(etd.thumbnail_id).to eq(etd.representative.id)

    # store these for comparison after adding files
    original_thumbnail_id = etd.thumbnail_id
    original_representative_id = etd.representative.id

    click_link 'Edit'
    sleep(2)

    click_link('Files')
    sleep(2)

    within('span#addfiles') do
      page.attach_file('files[]', "#{fixture_path}/files/pdf-sample.pdf", visible: false, wait: 5)
    end
    sleep(2)
    click_link 'Description'
    title = "Adding a PDF"
    fill_in 'Title', with: title
    fill_in 'Creator', with: 'Me'
    fill_in 'Keyword', with: 'Test'
    select('In Copyright', from: 'Rights')

    click_on('Save')
    # wait until we have a record
    persisted_etd = Etd.where(title: title) while persisted_etd.nil?

    within('.file_set.attributes .filename') do
      expect(page).to have_link('jpg-sample.jpg')
    end

    expect(original_thumbnail_id).to eq(etd.thumbnail_id)
    expect(original_representative_id).to eq(etd.representative.id)

    Etd.where(title_tesim: title).first.delete

    expect(Etd.all.size).to eq 0
  end

  # A new ETD is created and the user selects a Spreadsheet, a PDF, and another PDF, in that order and uploads them, then the thumbnail should be the first page of the spreadsheet
  scenario 'Creating an Etd with multiple files sets the first to representative media', :perform_enqueued, :datacite_api do
    ActiveJob::Base.queue_adapter.filter = [DataciteRegisterJob, AttachFilesToWorkJob]
    visit 'concern/etds/new'
    click_link 'Files'

    expect(page).to have_content "Add files"
    within('span#addfiles') do
      page.attach_file('files[]', "#{fixture_path}/files/xls-sample.xlsx", visible: false, wait: 5)
      page.attach_file('files[]', "#{fixture_path}/files/pdf-sample.pdf", visible: false, wait: 5)
      page.attach_file('files[]', "#{fixture_path}/files/pdf-sample-2.pdf", visible: false, wait: 5)
    end
    sleep(2)
    expect(Hyrax::UploadedFile.all.size).to eq 3

    click_link 'Description'
    sleep(2)
    title = "Spreadsheet and Pdfs"
    fill_in 'Title', with: title
    fill_in 'Creator', with: 'Me'
    fill_in 'Keyword', with: 'Test'
    select('In Copyright', from: 'Rights')

    expect(find('#with_files_submit')).not_to be_disabled
    click_on('Save')

    # wait until we have a record
    persisted_etd = Etd.where(title: title) while persisted_etd.nil?
    etd = persisted_etd.first

    expect(etd.representative.first_title).to eq('xls-sample.xlsx')

    Etd.where(title_tesim: title).first.delete
    expect(Etd.all.size).to eq 0
  end

  scenario "uploading a file creates a Hyrax::UploadedFile" do
    visit 'concern/etds/new'
    click_link 'Files'

    within('span#addfiles') do
      page.attach_file('files[]', "#{fixture_path}/files/pdf-sample.pdf", visible: false, wait: 5)
    end
    sleep(2)
    expect(Hyrax::UploadedFile.all.size).to eq 1

    Hyrax::UploadedFile.last.delete
    expect(Hyrax::UploadedFile.all.size).to eq 0
  end
end
