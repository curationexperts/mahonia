# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }
  let(:plain_user) { create(:user) }
  let(:admin_user) { create(:admin) }

  it_behaves_like 'a Hyrax User'

  it "has a display name" do
    expect(user.display_name).not_to be_empty
  end

  it '#to_s yeilds the #display_name' do
    expect(user.to_s).to eq user.display_name
  end

  describe 'roles' do
    it 'is emplty for a new user' do
      expect(plain_user.roles).to be_empty
    end

    it "#add_role adds a named role" do
      plain_user.add_role('some_role')
      expect(plain_user.roles.inspect).to match(/some_role/)
    end

    it "#add_role creates a new role if needed" do
      expect { plain_user.add_role('named_role') }.to change { Role.count }.by(1)
    end

    it "#add_role uses an existing role if it exists" do
      Role.create(name: 'existing_role')
      expect { plain_user.add_role('existing_role') }.not_to change { Role.count }
    end

    it "#remove_role removes a named role" do
      plain_user.add_role('new_role')
      expect { plain_user.remove_role('new_role') }.to change { plain_user.roles.count }.from(1).to(0)
    end

    it "#remove_role does nothing on non-existant names" do
      expect { plain_user.remove_role('nonexistent_role_name') }.not_to change { plain_user.roles.to_a }
    end
  end

  describe '#admin?' do
    it 'is false for regular user' do
      expect(plain_user).not_to be_admin
    end

    it 'is true when a user has the "admin" role' do
      expect(admin_user).to be_admin
    end
  end
end
