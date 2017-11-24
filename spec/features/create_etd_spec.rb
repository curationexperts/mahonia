# Generated via
#  `rails generate hyrax:work Etd`
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create an ETD', js: false, perform_enqueued: true do
  let(:title) { 'Comet in Moominland' }
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:etd) do
    FactoryBot.create(
      :moomins_thesis,
      user: admin,
      visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    )
  end

  before do
    ActiveJob::Base.queue_adapter.filter = [DataciteRegisterJob]
  end
  after do
    logout
  end

  context 'an admin user' do
    before do
      login_as admin
    end
    scenario 'can create a work' do
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

    scenario 'can edit a work' do
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
      visit "/concern/etds/#{etd.id}"
      expect(page).not_to have_content('Edit')
      visit "/concern/etds/#{etd.id}/edit"
      expect(page).to have_content('Unauthorized')
    end
  end
end
