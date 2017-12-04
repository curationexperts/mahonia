# frozen_string_literal: true
require 'rails_helper'
require 'fakes/fake_datacite_connection'
require 'fakes/fake_identifier_builder'

RSpec.describe DataciteRegisterJob, type: :job do
  let(:object) { create(:etd) }

  it_behaves_like 'an ApplicationJob'

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
        job.registrar_opts = { builder: builder, connection: connection }
      end
    end

    let(:builder)    { FakeIdentifierBuilder.new(id) }
    let(:connection) { FakeDataciteConnection.new }
    let(:id)         { 'moomin' }

    it 'adds an id to the object' do
      expect { job.perform(object) }
        .to change { object.identifier.to_a }
        .to contain_exactly id
    end

    # rubocop:disable RSpec/VerifiedDoubles
    it 'registers the id with metadata' do
      job.perform(object)

      expect(connection.get(metadata: double(identifier: id)))
        .to have_attributes(identifier: id,
                            titles:     object.title)
    end
    # rubocop:enable RSpec/VerifiedDoubles
  end
end
