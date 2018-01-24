# frozen_string_literal: true

require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Adding a new version for an existing file', :clean, :js do
  let(:etd) { FactoryBot.actor_create(:public_etd, jpg: jpg) }
  let(:jpg) { FactoryBot.create(:jpg_upload) }

  let(:admin) { FactoryBot.create(:admin) }

  context 'as an administrator' do
    before do
      login_as admin
      ActiveJob::Base.queue_adapter.filter = [IngestJob]
    end

    after { logout }

    scenario 'updates file content', :perform_enqueued do
      visit "concern/etds/#{etd.id}"

      find("#dropdownMenu_#{etd.representative.id}").click
      click_link('Versions')

      page.attach_file('file_set[files][]', "#{fixture_path}/files/pdf-sample.pdf", visible: false, wait: 5)

      content = etd.representative.files.first.content
      click_button 'Upload New Version'

      etd.representative.reload
      expect(etd.representative.files.first.content).not_to eq content
    end
  end

  context 'as another user' do
    let(:user) { FactoryBot.create(:user) }

    before { login_as user }
    after  { logout }

    scenario 'cannot add a version' do
      visit "concern/etds/#{etd.id}"
      find("#dropdownMenu_#{etd.representative.id}").click

      expect(page).not_to have_content 'Versions'
    end
  end
end
