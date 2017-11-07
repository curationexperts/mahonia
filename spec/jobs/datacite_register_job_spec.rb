require 'rails_helper'

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

  describe '.perform_now' do
    it 'adds an id to the object' do
      expect { described_class.perform_now(object) }
        .to change { object.identifier.to_a }
        .to contain_exactly 'moomin'
    end
  end
end
