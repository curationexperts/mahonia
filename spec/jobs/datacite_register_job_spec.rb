require 'rails_helper'
require 'fakes/fake_identifier_builder'

RSpec.describe DataciteRegisterJob, type: :job do
  let(:object) { create(:etd) }

  describe '.perform_later' do
    before { ActiveJob::Base.queue_adapter = :test }

    it 'enqueues the job' do
      expect { described_class.perform_later(object) }
        .to enqueue_job(described_class)
        .with(object)
        .on_queue('id_service')
    end
  end

  describe '.perform' do
    subject(:job) do
      described_class.new.tap do |job|
        job.registrar_opts = { builder: builder }
      end
    end

    let(:builder) { FakeIdentifierBuilder.new(id) }
    let(:id)      { 'moomin' }

    it 'adds an id to the object' do
      expect { job.perform(object) }
        .to change { object.identifier.to_a }
        .to contain_exactly id
    end
  end
end
