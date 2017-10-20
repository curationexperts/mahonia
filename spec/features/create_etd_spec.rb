# Generated via
#  `rails generate hyrax:work Etd`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Etd', js: false do
  context 'a logged in user' do
    let(:title) { 'Comet in Moominland' }
    let(:user)  { FactoryGirl.create(:user) }

    before { login_as user }

    scenario do
      visit '/dashboard'
      click_link 'Works'
      click_link 'Add new work'

      expect(page).to have_content 'Add New Etd'

      fill_in 'Title', with: title
      click_link 'Files'

      attach_file('files[]', File.absolute_path(file_fixture('pdf-sample.pdf')))
      find('#with_files_submit').click

      expect(page).to have_content title
    end
  end
end
