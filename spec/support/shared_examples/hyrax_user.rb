# frozen_string_literal: true
RSpec.shared_examples 'a Hyrax User' do
  describe '#ability' do
    it 'has abilities managed by Ability' do
      expect(user.ability).to be_a Ability
    end
  end

  describe '#email' do
    it 'is the set email' do
      expect { user.email = 'example.user@test.com' }
        .to change { user.email }
        .to 'example.user@test.com'
    end
  end

  describe '#password' do
    it 'is the set password' do
      expect { user.password = 'secret' }
        .to change { user.password }
        .to 'secret'
    end
  end
end
