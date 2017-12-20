# frozen_string_literal: true
RSpec.shared_examples 'an ApplicationJob', :perform_enqueued, type: :job do
  # handled by SideKiq
  describe 'retrying'

  describe 'discarding' do
    it 'does not raise to job queue on 410 Gone' do
      skip 'Set an object deserialize with `let(:deserialize_object)`' unless
        defined? deserialize_object
      skip unless deserialize_object.is_a? ActiveFedora::Core

      deserialize_object.destroy
      expect { described_class.perform_later(deserialize_object) }.not_to raise_error
    end
  end

  describe '.queue_as' do
    context 'when the queue is not known' do
      it 'raises an error' do
        expect { described_class.queue_as(:NOT_A_REAL_QUEUE) }
          .to raise_error ArgumentError, /NOT_A_REAL_QUEUE/
      end
    end
  end

  describe '.known_queues' do
    it 'contains :default' do
      expect(described_class.known_queues).to include :default
    end
  end
end
