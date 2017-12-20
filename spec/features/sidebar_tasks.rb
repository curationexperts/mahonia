# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.feature 'Display tasks in the sidebar', js: false do
  context 'as an admin user' do
    let(:user) { FactoryBot.create(:admin) }
    before { login_as user }
    it 'has a link to Sidekiq' do
      visit '/dashboard'
      expect(page).to have_link 'Sidekiq'
    end
  end
  context 'as a non-admin user' do
    let(:user) { FactoryBot.create(:user) }
    before { login_as user }
    it 'does not have a link to Sidekiq' do
      visit '/dashboard'
      expect(page).not_to have_link 'Sidekiq'
    end
  end
end
