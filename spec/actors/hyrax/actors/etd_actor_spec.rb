# frozen_string_literal: true
# Generated via
#  `rails generate hyrax:work Etd`
require 'rails_helper'

RSpec.describe Hyrax::Actors::EtdActor do
  subject(:actor)  { described_class.new(next_actor) }
  let(:ability)    { Ability.new(user) }
  let(:env)        { Hyrax::Actors::Environment.new(object, ability, {}) }
  let(:next_actor) { Hyrax::Actors::Terminator.new }
  let(:object)     { FactoryBot.create(:etd) }
  let(:user)       { FactoryBot.build(:user) }

  describe '#create' do
    context do
      before { ActiveJob::Base.queue_adapter = :test }

      it 'processes the MeSH terms' do
        expect { actor.create(env).to eq(true) }
      end
    end
  end

  describe '#update' do
    context do
      before { ActiveJob::Base.queue_adapter = :test }

      it 'processes the MeSH terms for editing' do
        expect { actor.create(env).to eq(true) }
      end
    end
  end
end
