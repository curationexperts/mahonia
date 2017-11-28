# frozen_string_literal: true
RSpec.shared_examples 'an ApplicationJob' do
  describe 'retrying'
  describe 'discarding'

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
