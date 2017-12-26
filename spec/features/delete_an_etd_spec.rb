# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Delete an OSHU ETD', js: false do
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:etd) do
    FactoryBot.create(
      :moomins_thesis,
      user: admin,
      visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    )
  end

  context 'an admin user' do
    before do
      login_as admin
      AdminSet.find_or_create_default_admin_set_id
    end

    after { logout }

    scenario 'can delete an OSHU Etd' do
      visit "concern/etds/#{etd.id}"

      click_on('Delete', match: :first)

      expect(page).to have_content("Deleted #{etd.title.first}")
    end
  end

  # Non admin users should not be able to delete an OSHU Etd

  context "a non-admin user" do
    before do
      login_as user
    end

    after { logout }

    scenario "cannot delete an OSHU Etd" do
      expect(user.admin?).to eq(false)
      visit "concern/etds/#{etd.id}"
      expect(page).not_to have_content('Delete')
    end
  end

  context "a non-authenticated user" do
    scenario "cannot delete an OSHU Etd" do
      # non-authenticated user can view public OSHU Etd
      visit "concern/etds/#{etd.id}"
      expect(page).to have_content etd.title.first.to_s
      # but cannot delete it
      expect(page).not_to have_content('Delete')
    end
  end
end
