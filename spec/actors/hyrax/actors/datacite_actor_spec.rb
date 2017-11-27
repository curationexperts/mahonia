# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Actors::DataciteActor do
  subject(:actor)  { described_class.new(next_actor) }
  let(:ability)    { Ability.new(user) }
  let(:env)        { Hyrax::Actors::Environment.new(object, ability, {}) }
  let(:next_actor) { Hyrax::Actors::Terminator.new }
  let(:object)     { FactoryBot.create(:etd) }
  let(:user)       { FactoryBot.build(:user) }

  it { expect(described_class).to act.and_succeed }

  describe '#create' do
    context do
      before { ActiveJob::Base.queue_adapter = :test }

      it 'enqueues a job' do
        expect { actor.create(env) }
          .to have_enqueued_job(DataciteRegisterJob)
          .with(object)
          .on_queue('id_service')
      end
    end
  end
end
