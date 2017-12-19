# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Edit an OSHU ETD', :clean, js: false do
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:etd) do
    FactoryBot.create(
      :moomins_thesis,
      user: admin,
      visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    )
  end
  after { logout }
  context 'an admin user' do
    before do
      login_as admin
      AdminSet.find_or_create_default_admin_set_id
    end
    scenario 'can edit an Etd' do
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

  context "a non-admin user" do
    before do
      login_as user
    end
    scenario "cannot edit a work" do
      visit "/concern/etds/#{etd.id}"
      expect(page).not_to have_content('Edit')
      visit "/concern/etds/#{etd.id}/edit"
      expect(page).to have_content('Unauthorized')
    end
  end
end
