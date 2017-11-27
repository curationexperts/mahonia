# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Etd`
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create a Etd', js: false, perform_enqueued: true do
  context 'as a logged in user' do
    let(:title) { 'Comet in Moominland' }
    let(:user)  { FactoryGirl.create(:user) }

    before do
      ActiveJob::Base.queue_adapter.filter = [DataciteRegisterJob]
      login_as user
    end

    scenario 'creating' do
      visit '/dashboard'
      click_link 'Works'
      click_link 'Add new work'

      expect(page).to have_content 'Add New Etd'

      fill_in 'Title', with: title
      click_link 'Files'

      within('#addfiles') do
        attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')))
      end

      find('#with_files_submit').click

      expect(page).to have_content title # sets title
      expect(page).to have_css('.identifier', text: '10.5072') # assigns DOI
    end

    scenario 'editing' do
      etd = FactoryGirl.create(:moomins_thesis, user: user)

      visit "concern/etds/#{etd.id}"
      click_link 'Edit'

      new_title   = 'Finn Family Moomintroll'
      new_keyword = 'moomin'

      fill_in 'Title',   with: new_title
      fill_in 'Keyword', with: new_keyword
      find('#with_files_submit').click

      expect(page).to have_content(new_title, new_keyword)
    end
  end
end
