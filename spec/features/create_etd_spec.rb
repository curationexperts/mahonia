# Generated via
#  `rails generate hyrax:work Etd`
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Create a Etd', js: false do
  context 'as a logged in user' do
    let(:title) { 'Comet in Moominland' }
    let(:user)  { FactoryGirl.create(:user) }

    before { login_as user }

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

      expect(page).to have_content title
    end

    scenario 'editing' do
      etd = FactoryGirl.create(:etd, user: user)

      visit "concern/etds/#{etd.id}"
      click_link 'Edit'

      new_title = 'Finn Family Moomintroll'

      fill_in 'Title', with: new_title
      find('#with_files_submit').click

      expect(page).to have_content new_title
    end
  end
end
